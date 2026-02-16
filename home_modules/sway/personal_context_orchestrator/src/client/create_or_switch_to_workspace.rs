use anyhow::Result;
use std::process::Command;
use swayipc::Connection;

use crate::context_aware_workspace::{ContextAwareWorkspace, ContextAwareWorkspaces};
use crate::manage_context_daemon::get_context;
use crate::wofi;

pub fn create_or_switch_to_workspace(letter: char) -> Result<()> {
    let current_context = get_context()?;
    let workspaces = ContextAwareWorkspaces::read()?;

    let mut matches: Vec<ContextAwareWorkspace> = workspaces
        .items
        .into_iter()
        .filter(|caw| {
            caw.context_name == current_context && caw.first_letter_of_workspace_matches(&letter)
        })
        .collect();

    let mut conn = Connection::new()?;
    match matches.len() {
        0 => {
            // Case 1: No matching workspace → select program from PATH
            let program = wofi::select_program_from_path(letter)?;
            conn.run_command(format!("workspace {}", program))?;
            conn.run_command(format!(
                "exec systemd-run --user --scope --quiet {}",
                program
            ))?;
        }

        1 => {
            let singleton_result = matches.remove(0);
            conn.run_command(format!(
                "workspace {}",
                singleton_result.workspace_display_name
            ))?;
        }

        _ => {
            let option_names: Vec<String> = matches
                .iter()
                .map(|caw| caw.workspace_display_name.clone())
                .collect();

            let selected = wofi::select_from_list("Workspace:", &option_names)?;

            conn.run_command(format!("workspace {}", selected))?;
        }
    };

    Ok(())
}
