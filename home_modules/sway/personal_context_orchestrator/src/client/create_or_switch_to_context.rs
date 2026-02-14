use crate::context_aware_workspace::{
    ContextAwareWorkspace, ContextAwareWorkspaces, WorkspaceName,
};
use crate::manage_context_daemon::set_context;
use crate::wofi;
use anyhow::Result;
use swayipc::Connection;

pub fn create_or_switch_to_context(letter: char) -> Result<()> {
    let workspaces = ContextAwareWorkspaces::read()?;

    let contexts = workspaces.filter_by_context_first_letter(letter);

    let selected_context = wofi::select_from_list("Context:", &contexts)?;

    let target_workspace = workspaces
        .items
        .into_iter()
        .find(|caw| caw.context_name == selected_context)
        .unwrap_or(ContextAwareWorkspace {
            workspace_display_name: "1".to_string(),
            context_name: selected_context.clone(),
        });

    println!("{}", WorkspaceName::from(target_workspace.clone()));

    let mut conn = Connection::new()?;
    conn.run_command(format!(
        "workspace {}",
        WorkspaceName::from(target_workspace)
    ))?;

    set_context(&selected_context)?;

    Ok(())
}
