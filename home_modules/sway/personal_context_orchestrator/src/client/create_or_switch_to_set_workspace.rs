use std::process::Command;

use anyhow::Result;
use swayipc::Connection;

use crate::context_aware_workspace::{ContextAwareWorkspace, ContextAwareWorkspaces};
use crate::manage_context_daemon::get_context;

pub fn create_or_switch_to_set_workspace(
    workspace_display_name: &String,
    executable_path: &String,
) -> Result<()> {
    let current_context = get_context()?;
    let workspaces = ContextAwareWorkspaces::read()?;

    let mut matches: Option<ContextAwareWorkspace> = workspaces.items.into_iter().find(|caw| {
        caw.context_name == current_context && caw.workspace_display_name == *workspace_display_name
    });

    let mut conn = Connection::new()?;

    let workspace_name =
        ContextAwareWorkspace::create_workspace_name(workspace_display_name, &current_context);
    match matches {
        Some(_) => {
            conn.run_command(format!("workspace {}", workspace_name))?;
        }
        None => {
            let command_string = format!(
                "workspace {}; exec systemd-run --user --scope --quiet {}",
                workspace_name, executable_path
            );

            conn.run_command(command_string)?;
        }
    }
    Ok(())
}
