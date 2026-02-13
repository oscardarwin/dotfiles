use anyhow::Result;
use std::process::Command;
use swayipc::Connection;

use crate::context_aware_workspace::{ContextAwareWorkspace, ContextAwareWorkspaces};
use crate::manage_context_daemon::get_context;
use crate::wofi;

pub fn create_or_switch_to_workspace(letter: char) -> Result<()> {
    let current_context = get_context()?;

    let workspaces = ContextAwareWorkspaces::read()?;

    let maybe_workspace = workspaces.items.into_iter().find(|caw| {
        caw.context_name == current_context
            && caw
                .workspace_display_name
                .chars()
                .next()
                .map(|c| c.eq_ignore_ascii_case(&letter))
                .unwrap_or(false)
    });

    let is_new_workspace = maybe_workspace.is_none();

    let target_workspace = maybe_workspace.unwrap_or_else(|| {
        let program = wofi::select_program().expect("Failed to launch wofi run");

        ContextAwareWorkspace {
            workspace_display_name: program,
            context_name: current_context.clone(),
        }
    });

    let workspace_name = String::from(target_workspace.clone());

    let mut conn = Connection::new()?;
    conn.run_command(format!("workspace {}", workspace_name))?;

    if is_new_workspace {
        Command::new(&target_workspace.workspace_display_name).spawn()?;
    }

    Ok(())
}
