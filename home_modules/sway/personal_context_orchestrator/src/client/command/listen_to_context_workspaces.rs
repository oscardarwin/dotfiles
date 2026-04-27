use anyhow::Result;
use serde::Serialize;
use swayipc::{Connection, EventType};

use crate::{
    context_workspace::{Context, ContextWorkspace, ContextWorkspaces},
    manage_context_daemon::get_context,
};
use serde_json::json;
use std::collections::BTreeSet;

#[derive(Serialize, Ord, Eq, PartialEq, PartialOrd)]
struct ContextWithFocus {
    pub context: Context,
    pub focused: bool,
}

#[derive(Serialize, Ord, Eq, PartialEq, PartialOrd)]
struct OutputWithIndex {
    pub output: String,
    pub index: String,
}

#[derive(Serialize)]
struct ContextWorkspacesInfo {
    contexts: BTreeSet<ContextWithFocus>,
    outputs: BTreeSet<OutputWithIndex>,
    workspaces: Vec<ContextWorkspace>,
}

fn print_context_workspaces_info() -> Result<()> {
    let ContextWorkspaces { mut items } = ContextWorkspaces::read()?;

    let current_context = get_context()?;

    let mut contexts: BTreeSet<Context> = BTreeSet::new();
    let mut outputs: BTreeSet<String> = BTreeSet::new();

    items.sort_by_key(|context_workspace| String::from(context_workspace));

    let workspaces = items
        .into_iter()
        .map(|caw| {
            contexts.insert(caw.context.clone());
            outputs.insert(caw.output.clone());
            caw
        })
        .filter(|caw| caw.context.name == current_context)
        .collect();

    let contexts_with_focus = contexts
        .into_iter()
        .map(|context| ContextWithFocus {
            focused: context.name == current_context,
            context,
        })
        .collect();

    let indexed_outputs = outputs
        .into_iter()
        .enumerate()
        .map(|(index, output)| OutputWithIndex {
            index: index.to_string(),
            output,
        })
        .collect();

    println!(
        "{}",
        json!(ContextWorkspacesInfo {
            contexts: contexts_with_focus,
            outputs: indexed_outputs,
            workspaces
        })
    );

    Ok(())
}

pub fn listen_to_context_workspaces() -> Result<()> {
    print_context_workspaces_info()?;

    let events_stream_connection = Connection::new()?;
    let event_stream = events_stream_connection.subscribe([EventType::Workspace])?;
    for _ in event_stream {
        print_context_workspaces_info()?;
    }

    Ok(())
}
