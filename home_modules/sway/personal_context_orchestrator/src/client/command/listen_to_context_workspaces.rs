use anyhow::Result;
use serde::Serialize;
use swayipc::{Connection, EventType};

use crate::context_workspace::{Context, ContextWorkspace, ContextWorkspaces, Output, Space};
use serde_json::json;
use std::collections::BTreeSet;

#[derive(Serialize, Ord, Eq, PartialEq, PartialOrd)]
struct ContextWithFocus {
    pub context: Context,
    pub focused: bool,
}

#[derive(Serialize, Ord, Eq, PartialEq, PartialOrd)]
struct OutputWithFocus {
    pub output: Output,
    pub focused: bool,
}

#[derive(Serialize, Ord, Eq, PartialEq, PartialOrd)]
struct SpaceWithFocus {
    pub space: Space,
    pub focused: bool,
}

#[derive(Serialize)]
struct ContextWorkspacesInfo {
    contexts: BTreeSet<ContextWithFocus>,
    outputs: Vec<OutputWithFocus>,
    spaces: BTreeSet<SpaceWithFocus>,
}

fn print_context_workspaces_info() -> Result<()> {
    let workspaces = ContextWorkspaces::read()?;

    let focused_workspace = workspaces.get_focused()?.clone();

    let ContextWorkspaces { mut items } = workspaces;

    let mut contexts: BTreeSet<Context> = BTreeSet::new();

    items.sort_by_key(|context_workspace| String::from(context_workspace));

    let workspaces_in_context: Vec<ContextWorkspace> = items
        .into_iter()
        .map(|caw| {
            contexts.insert(caw.context.clone());
            caw
        })
        .filter(|caw| caw.context.name == focused_workspace.context.name)
        .collect();

    let contexts_with_focus = contexts
        .into_iter()
        .map(|context| ContextWithFocus {
            focused: context.name == focused_workspace.context.name,
            context,
        })
        .collect();

    let mut conn = Connection::new()?;

    let mut outputs: Vec<OutputWithFocus> = conn
        .get_outputs()?
        .into_iter()
        .enumerate()
        .map(|(index, output)| OutputWithFocus {
            output: Output::new((index + 1).to_string(), output.name),
            focused: output.focused,
        })
        .collect();

    outputs.sort_by_key(|output| output.output.name.clone());

    let spaces_set: BTreeSet<Space> = workspaces_in_context
        .into_iter()
        .map(|workspace| workspace.space.clone())
        .collect();

    let spaces = spaces_set
        .into_iter()
        .map(|space| SpaceWithFocus {
            focused: space.name == focused_workspace.space.name,
            space,
        })
        .collect();

    println!(
        "{}",
        json!(ContextWorkspacesInfo {
            contexts: contexts_with_focus,
            outputs,
            spaces,
        })
    );

    Ok(())
}

pub fn listen_to_context_workspaces() -> Result<()> {
    print_context_workspaces_info()?;

    let events_stream_connection = Connection::new()?;
    let event_stream =
        events_stream_connection.subscribe([EventType::Workspace, EventType::Output])?;
    for _ in event_stream {
        print_context_workspaces_info()?;
    }

    Ok(())
}
