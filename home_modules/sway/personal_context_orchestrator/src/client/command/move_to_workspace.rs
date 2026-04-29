use anyhow::Result;
use std::collections::BTreeSet;
use swayipc::Connection;

use crate::context_workspace::{ContextWorkspace, ContextWorkspaces, WorkspaceName};
use crate::wofi;

pub fn move_to_workspace(letter: char) -> Result<()> {
    let workspaces = ContextWorkspaces::read()?;
    let focused = workspaces.get_focused()?.clone();

    let mut matches: BTreeSet<WorkspaceName> = workspaces
        .items
        .into_iter()
        .filter(|caw| {
            caw.context.name == focused.context.name
                && caw.first_letter_of_workspace_matches(&letter)
        })
        .map(|caw| caw.space.name.clone())
        .collect();

    let space_name = match matches.len() {
        0 => wofi::select_from_list("New Workspace:", &Vec::new())?,

        1 => matches
            .pop_first()
            .expect("set should contain exactly one element"),

        _ => {
            let option_names = matches.into_iter().collect();

            wofi::select_from_list("Workspace:", &option_names)?
        }
    };

    let workspace_name =
        ContextWorkspace::create_workspace_name(&space_name, &focused.context.name);

    let mut conn = Connection::new()?;
    conn.run_command(format!("move container to workspace {}", workspace_name))?;
    conn.run_command(format!("workspace {}", workspace_name))?;

    Ok(())
}
