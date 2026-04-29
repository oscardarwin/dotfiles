use anyhow::Result;
use swayipc::Connection;

use crate::context_workspace::{ContextWorkspace, ContextWorkspaces};
use crate::wofi;

pub fn create_or_switch_to_workspace(letter: char) -> Result<()> {
    let workspaces = ContextWorkspaces::read()?;
    let focused = workspaces.get_focused()?.clone();

    let current_context = &focused.context.name;

    let matches: Option<ContextWorkspace> = workspaces.items.into_iter().find(|caw| {
        caw.context.name == *current_context && caw.first_letter_of_workspace_matches(&letter)
    });

    let mut conn = Connection::new()?;
    match matches {
        None => {
            let workspace_name =
                ContextWorkspace::create_workspace_name(&letter.to_string(), current_context);

            conn.run_command(format!("workspace {}", workspace_name))?;

            let program = wofi::select_program_from_path(letter)?;

            conn.run_command(format!(
                "exec systemd-run --user --scope --quiet {}",
                program
            ))?;
        }

        Some(singleton_result) => {
            let workspace_label = String::from(&singleton_result);

            println!("switching to workspace {}", workspace_label);
            conn.run_command(format!("workspace {}", workspace_label))?;
        }
    };

    Ok(())
}
