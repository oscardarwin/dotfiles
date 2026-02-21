use std::collections::BTreeSet;

use crate::context_workspace::{ContextName, ContextWorkspace, ContextWorkspaces};
use crate::manage_context_daemon::set_context;
use crate::wofi;
use anyhow::Result;
use swayipc::Connection;

fn matches_first_letter(word: &String, letter: &char) -> bool {
    word.chars()
        .next()
        .map_or(false, |c| c.eq_ignore_ascii_case(letter))
}

fn filter_by_context_first_letter(
    context_workspaces: &ContextWorkspaces,
    letter: char,
) -> Vec<ContextName> {
    let deduplicated: BTreeSet<_> = context_workspaces
        .items
        .iter()
        .filter(|caw| matches_first_letter(&caw.context.name, &letter))
        .map(|caw| caw.context.name.clone())
        .collect();

    deduplicated.into_iter().collect()
}

pub fn create_or_switch_to_context(letter: char) -> Result<()> {
    let workspaces = ContextWorkspaces::read()?;

    let mut contexts = filter_by_context_first_letter(&workspaces, letter);

    let selected_context = match contexts.len() {
        1 => contexts.remove(0),
        _ => wofi::select_from_list("Context:", &contexts)?,
    };

    let target_workspace = workspaces
        .items
        .into_iter()
        .find(|caw| caw.context.name == selected_context)
        .unwrap_or(ContextWorkspace::new("1".to_string(), selected_context.clone(), true).unwrap());

    println!("{}", String::from(&target_workspace));

    let mut conn = Connection::new()?;
    conn.run_command(format!("workspace {}", String::from(&target_workspace)))?;

    set_context(&selected_context)?;

    Ok(())
}
