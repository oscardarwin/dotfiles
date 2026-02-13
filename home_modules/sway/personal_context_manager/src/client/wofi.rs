use anyhow::{anyhow, Result};
use std::collections::BTreeSet;
use std::env;
use std::fs;
use std::io::Write;
use std::os::unix::fs::PermissionsExt;
use std::path::PathBuf;
use std::process::{Command, Stdio};

pub fn select_from_list(prompt: &str, options: &[String]) -> Result<String> {
    let input = options.join("\n");

    let mut child = Command::new("wofi")
        .arg("--dmenu")
        .arg("--prompt")
        .arg(prompt)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()?;

    {
        let stdin = child
            .stdin
            .as_mut()
            .ok_or_else(|| anyhow!("Failed to open stdin"))?;
        stdin.write_all(input.as_bytes())?;
    }

    let output = child.wait_with_output()?;
    let selected = String::from_utf8(output.stdout)?.trim().to_string();

    if selected.is_empty() {
        anyhow::bail!("No selection made");
    }

    Ok(selected)
}
fn executables_in_path() -> Result<Vec<String>> {
    let path_var = env::var("PATH")?;

    let programs: BTreeSet<String> = path_var
        .split(':')
        .map(PathBuf::from)
        .filter_map(|dir| fs::read_dir(dir).ok())
        .flat_map(|entries| entries.filter_map(Result::ok))
        .filter_map(|entry| {
            let metadata = entry.metadata().ok()?;
            if entry.file_type().ok()?.is_file() && (metadata.permissions().mode() & 0o111 != 0) {
                entry.file_name().into_string().ok()
            } else {
                None
            }
        })
        .collect();

    Ok(programs.into_iter().collect())
}

pub fn select_program() -> Result<String> {
    let programs = executables_in_path()?;
    select_from_list("Run:", &programs)
}
