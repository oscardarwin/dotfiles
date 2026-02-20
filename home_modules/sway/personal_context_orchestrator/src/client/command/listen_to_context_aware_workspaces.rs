use anyhow::Result;
use serde::Serialize;
use swayipc::{Connection, EventType};

use crate::{
    context_aware_workspace::{
        ContextAwareWorkspace, ContextAwareWorkspaces, ContextName, WorkspaceName,
    },
    manage_context_daemon::get_context,
};

use serde_json::json;
use std::collections::{BTreeMap, BTreeSet};

struct EmptyNameError;

#[derive(Serialize)]
struct ContextWithFirstChar {
    first_char: char,
    label: String,
}

impl ContextWithFirstChar {
    pub fn new(label: String) -> Option<Self> {
        let first_char = label.chars().next()?;

        Some(Self { first_char, label })
    }
}

#[derive(Serialize)]
struct ContextAwareWorkspacesInfo {
    contexts: Vec<ContextWithFirstChar>,
    workspaces: Vec<ContextAwareWorkspace>,
}

fn get_labels_with_first_char(labels: BTreeSet<String>) -> Vec<ContextWithFirstChar> {
    labels
        .into_iter()
        .filter_map(|label| ContextWithFirstChar::new(label))
        .collect()
}

fn print_context_aware_workspaces() -> Result<()> {
    let ContextAwareWorkspaces { items } = ContextAwareWorkspaces::read()?;

    let current_context = get_context()?;

    let mut context_names: BTreeSet<ContextName> = BTreeSet::new();

    let workspaces = items
        .into_iter()
        .map(|caw| {
            context_names.insert(caw.context_name.clone());
            caw
        })
        .filter(|caw| caw.context_name == current_context)
        .collect();

    let contexts = get_labels_with_first_char(context_names);

    println!(
        "{}",
        json!(ContextAwareWorkspacesInfo {
            contexts,
            workspaces
        })
    );

    Ok(())
}

pub fn listen_to_context_aware_workspaces() -> Result<()> {
    print_context_aware_workspaces()?;

    let events_stream_connection = Connection::new()?;
    let event_stream = events_stream_connection.subscribe([EventType::Workspace])?;
    for _ in event_stream {
        print_context_aware_workspaces()?;
    }

    Ok(())
}
