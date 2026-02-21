use anyhow::Result;
use swayipc::Connection;

use crate::context_workspace::{ContextWorkspace, ContextWorkspaces};
use crate::manage_context_daemon::get_context;

pub fn create_or_switch_to_set_workspace(
    workspace_display_name: &String,
    executable_path: &String,
) -> Result<()> {
    let current_context = get_context()?;
    let workspaces = ContextWorkspaces::read()?;

    let matches: Option<ContextWorkspace> = workspaces
        .items
        .into_iter()
        .find(|caw| caw.context.name == current_context && caw.name == *workspace_display_name);

    let mut conn = Connection::new()?;

    let workspace_name =
        ContextWorkspace::create_workspace_name(workspace_display_name, &current_context);

    match matches {
        Some(_) => {
            println!("switching to workspace {}", workspace_name);
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
