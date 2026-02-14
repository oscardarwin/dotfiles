use anyhow::Result;
use std::collections::HashMap;
use std::process::Command;
use swayipc::Connection;

use crate::context_aware_workspace::{ContextAwareWorkspace, ContextAwareWorkspaces};
use crate::manage_context_daemon::get_context;
use crate::wofi;

pub fn move_to_workspace(letter: char) -> Result<()> {
    let current_context = get_context()?;
    let workspaces = ContextAwareWorkspaces::read()?;

    let mut matches: Vec<ContextAwareWorkspace> = workspaces
        .items
        .into_iter()
        .filter(|caw| {
            caw.context_name == current_context && caw.first_letter_of_workspace_matches(&letter)
        })
        .collect();

    let is_new_workspace = matches.is_empty();

    let target_workspace = match matches.len() {
        0 => {
            let program = wofi::select_from_list("New Workspace:", &Vec::new())?;

            ContextAwareWorkspace {
                workspace_display_name: program,
                context_name: current_context.clone(),
            }
        }

        1 => matches.remove(0),

        _ => {
            let options: HashMap<String, ContextAwareWorkspace> = matches
                .into_iter()
                .map(|caw| (caw.workspace_display_name.clone(), caw))
                .collect();

            // Collect keys into a Vec<String> first (owned, stable)
            let option_names: Vec<String> = options.keys().cloned().collect();

            let selected = wofi::select_from_list("Workspace:", &option_names)?;

            // Now safely retrieve
            options
                .get(&selected)
                .expect("Selected workspace not found")
                .clone()
        }
    };

    let workspace_name = String::from(target_workspace.clone());

    let mut conn = Connection::new()?;
    conn.run_command(format!("move container to workspace {}", workspace_name))?;

    // Only launch program if this is a newly created workspace
    if is_new_workspace {
        Command::new(&target_workspace.workspace_display_name).spawn()?;
    }

    Ok(())
}
