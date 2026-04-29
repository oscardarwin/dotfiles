use anyhow::Result;
use itertools::Itertools;
use serde::Serialize;
use std::collections::VecDeque;
use swayipc::{Connection, EventType};

use crate::context_workspace::{Context, ContextWorkspace, ContextWorkspaces};
use serde_json::json;
use std::collections::{BTreeSet, HashMap};

#[derive(Serialize, Ord, Eq, PartialEq, PartialOrd)]
struct Label {
    pub tooltip: String,
    pub text: String,
    pub highlighted: bool,
    pub onclick: String,
    pub class: String,
}

fn print_context_workspaces_info() -> Result<()> {
    let workspaces = ContextWorkspaces::read()?;

    let focused_workspace = workspaces.get_focused()?.clone();

    let ContextWorkspaces { mut items } = workspaces;

    let mut contexts_containing_workspaces: BTreeSet<Context> = BTreeSet::new();

    items.sort_by_key(|context_workspace| String::from(context_workspace));

    let workspaces_in_context: Vec<ContextWorkspace> = items
        .into_iter()
        .map(|caw| {
            contexts_containing_workspaces.insert(caw.context.clone());
            caw
        })
        .filter(|caw| caw.context.name == focused_workspace.context.name)
        .collect();

    let mut context_labels: Vec<Label> = contexts_containing_workspaces
        .into_iter()
        .map(|context| Label {
            highlighted: context.name == focused_workspace.context.name,
            tooltip: context.name,
            text: context.associated_char.to_string(),
            onclick: format!("create-or-switch-to-context {}", context.associated_char),
            class: "context-button".to_string(),
        })
        .collect();

    let spaces: HashMap<String, Vec<ContextWorkspace>> = workspaces_in_context
        .into_iter()
        .into_group_map_by(|caw| caw.output.clone());

    let mut conn = Connection::new()?;
    let output_labels: Vec<Label> = conn
        .get_outputs()?
        .into_iter()
        .enumerate()
        .filter_map(|(index, output)| {
            let mut labels: VecDeque<Label> = spaces
                .get(&output.name)?
                .iter()
                .map(|caw| Label {
                    tooltip: caw.space.name.clone(),
                    text: caw.space.associated_char.to_string(),
                    highlighted: caw.visible,
                    onclick: format!(
                        "create-or-switch-to-workspace {}",
                        caw.space.associated_char
                    ),
                    class: "workspace-button".to_string(),
                })
                .collect();

            let output_id = (index + 1).to_string();

            let output_label = Label {
                tooltip: output.name,
                onclick: format!("switch-to-output {}", output_id),
                text: output_id,
                highlighted: output.focused,
                class: "output-button".to_string(),
            };

            labels.push_front(output_label);

            Some(labels)
        })
        .flatten()
        .collect();

    context_labels.extend(output_labels);

    println!("{}", json!(context_labels));

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
