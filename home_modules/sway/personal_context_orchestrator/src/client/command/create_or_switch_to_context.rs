use crate::context_workspace::{ContextWorkspace, ContextWorkspaces};
use crate::wofi;
use anyhow::Result;
use swayipc::Connection;

pub fn create_or_switch_to_context(letter: char) -> Result<()> {
    let workspaces = ContextWorkspaces::read()?;

    let focused = workspaces.get_focused()?.clone();

    let mut contexts = workspaces.filter_by_context_first_letter(letter);

    let selected_context = match contexts.len() {
        1 => contexts.remove(0),
        _ => wofi::select_from_list("Context:", &contexts)?,
    };

    let workspaces_with_context: Vec<ContextWorkspace> = workspaces
        .items
        .into_iter()
        .filter(|caw| caw.context.name == selected_context)
        .collect();

    let target_workspace = workspaces_with_context
        .iter()
        .find(|cw| cw.space.name == focused.space.name)
        .or(workspaces_with_context.iter().next())
        .cloned()
        .unwrap_or(
            ContextWorkspace::new(
                "1".to_string(),
                selected_context.clone(),
                focused.output.clone(),
                true,
                true,
            )
            .unwrap(),
        );

    let mut conn = Connection::new()?;
    conn.run_command(format!("workspace {}", String::from(&target_workspace)))?;

    Ok(())
}
