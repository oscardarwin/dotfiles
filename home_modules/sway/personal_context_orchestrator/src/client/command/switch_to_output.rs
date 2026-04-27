use crate::context_workspace::{ContextWorkspace, ContextWorkspaces};
use anyhow::Result;
use swayipc::Connection;

pub fn switch_to_output(letter: char) -> Result<()> {
    let workspaces = ContextWorkspaces::read()?;

    let focused = workspaces.get_focused()?.clone();

    let workspace = ContextWorkspace::create_workspace_name(
        &focused.name,
        &focused.context.name,
        &letter.to_string(),
    );

    let mut conn = Connection::new()?;
    conn.run_command(format!("workspace {}", workspace))?;

    Ok(())
}
