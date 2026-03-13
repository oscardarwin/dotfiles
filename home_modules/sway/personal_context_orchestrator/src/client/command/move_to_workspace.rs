use anyhow::Result;
use swayipc::Connection;

use crate::context_workspace::{ContextWorkspace, ContextWorkspaces};
use crate::manage_context_daemon::get_context;
use crate::wofi;

pub fn move_to_workspace(letter: char) -> Result<()> {
    let current_context = get_context()?;
    let workspaces = ContextWorkspaces::read()?;

    let mut matches: Vec<ContextWorkspace> = workspaces
        .items
        .into_iter()
        .filter(|caw| {
            caw.context.name == current_context && caw.first_letter_of_workspace_matches(&letter)
        })
        .collect();

    let workspace_name = match matches.len() {
        0 => {
            let workspace_display_name = wofi::select_from_list("New Workspace:", &Vec::new())?;
            ContextWorkspace::create_workspace_name(&workspace_display_name, &current_context)
        }

        1 => String::from(&matches.remove(0)),

        _ => {
            let option_names: Vec<String> = matches.iter().map(|caw| caw.name.clone()).collect();

            let workspace_display_name = wofi::select_from_list("Workspace:", &option_names)?;
            ContextWorkspace::create_workspace_name(&workspace_display_name, &current_context)
        }
    };

    let mut conn = Connection::new()?;
    conn.run_command(format!("move container to workspace {}", workspace_name))?;
    conn.run_command(format!("workspace {}", workspace_name))?;

    Ok(())
}
