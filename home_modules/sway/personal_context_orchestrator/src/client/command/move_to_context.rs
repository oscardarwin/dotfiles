use anyhow::Result;
use swayipc::Connection;

use crate::context_workspace::{ContextWorkspace, ContextWorkspaces};
use crate::wofi;

pub fn move_to_context(letter: char) -> Result<()> {
    let workspaces = ContextWorkspaces::read()?;

    let mut target_contexts = workspaces.filter_by_context_first_letter(letter);

    let focused = workspaces.get_focused()?.clone();

    let context_name = match target_contexts.len() {
        0 => wofi::select_from_list("New Context:", &Vec::new())?,

        1 => String::from(&target_contexts.remove(0)),

        _ => wofi::select_from_list("Workspace:", &target_contexts)?,
    };

    let workspace =
        ContextWorkspace::create_workspace_name(&focused.name, &context_name, &focused.output);

    let mut conn = Connection::new()?;
    conn.run_command(format!("move container to workspace {}", &workspace))?;
    conn.run_command(format!("workspace {}", workspace))?;

    Ok(())
}
