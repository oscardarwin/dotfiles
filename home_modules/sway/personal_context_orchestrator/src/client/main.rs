use anyhow::{anyhow, Ok, Result};
use std::env;

mod command;
mod context_workspace;
mod manage_context_daemon;
mod wofi;

fn get_first_character(arg: &String) -> Result<char> {
    arg.chars()
        .next()
        .ok_or_else(|| anyhow!("Letter argument cannot be empty"))
}

fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();

    match args.get(1).map(|s| s.as_str()) {
        Some("create-or-switch-to-context") => {
            let letter_str = args
                .get(2)
                .ok_or_else(|| anyhow!("Usage: client create-or-switch-to-context <letter>"))?;

            let character = get_first_character(letter_str)?;
            command::create_or_switch_to_context(character)
        }
        Some("move-to-context") => {
            let letter_str = args
                .get(2)
                .ok_or_else(|| anyhow!("Usage: client create-or-switch-to-workspace <letter>"))?;

            let character = get_first_character(letter_str)?;
            command::move_to_context(character)
        }
        Some("create-or-switch-to-workspace") => {
            let letter_str = args
                .get(2)
                .ok_or_else(|| anyhow!("Usage: client create-or-switch-to-workspace <letter>"))?;

            let character = get_first_character(letter_str)?;
            command::create_or_switch_to_workspace(character)
        }
        Some("move-to-workspace") => {
            let letter_str = args
                .get(2)
                .ok_or_else(|| anyhow!("Usage: client move-to-workspace <letter>"))?;

            let character = get_first_character(letter_str)?;
            command::move_to_workspace(character)
        }
        Some("create-or-switch-to-set-workspace") => {
            let workspace_display_name = args
                .get(2)
                .ok_or_else(|| anyhow!("Usage: client create-or-switch-to-set-workspace <workspace_display_name> <executable_path>"))?;

            let executable_path = args
                .get(3)
                .ok_or_else(|| anyhow!("Usage: client create-or-switch-to-set-workspace <workspace_display_name> <executable_path>"))?;

            command::create_or_switch_to_set_workspace(workspace_display_name, executable_path)
        }
        Some("get") => manage_context_daemon::get_context().map(|context| {
            println!("Context: {}", &context);
            ()
        }),
        Some("set") => {
            let value = args
                .get(2)
                .ok_or_else(|| anyhow!("Usage: client set <value>"))?;
            manage_context_daemon::set_context(value)
        }
        Some("listen-to-context-workspaces") => loop {
            _ = command::listen_to_context_workspaces();
            std::thread::sleep(std::time::Duration::from_secs(1));
        },
        _ => {
            eprintln!("Usage:");
            eprintln!("  client create-or-switch");
            eprintln!("  client get");
            eprintln!("  client set <value>");
            Ok(())
        }
    }
}
