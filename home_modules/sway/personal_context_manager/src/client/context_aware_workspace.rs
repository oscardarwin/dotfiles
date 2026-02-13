use anyhow::Result;
use swayipc::{Connection, Workspace};

pub type WorkspaceName = String;

/// Represents a workspace split into display name and context
#[derive(Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct ContextAwareWorkspace {
    pub workspace_display_name: String, // e.g., "qutebrowser"
    pub context_name: String,           // e.g., "code"
}

impl From<&str> for ContextAwareWorkspace {
    fn from(s: &str) -> Self {
        let mut parts = s.splitn(2, ':');
        let context_name = parts.next().unwrap_or("").to_string();
        let workspace_display_name = parts.next().unwrap_or("").to_string();
        ContextAwareWorkspace {
            workspace_display_name,
            context_name,
        }
    }
}

impl From<ContextAwareWorkspace> for WorkspaceName {
    fn from(caw: ContextAwareWorkspace) -> Self {
        format!("{}:{}", caw.context_name, caw.workspace_display_name)
    }
}

/// Collection of ContextAwareWorkspace
#[derive(Clone)]
pub struct ContextAwareWorkspaces {
    pub items: Vec<ContextAwareWorkspace>,
}

impl ContextAwareWorkspaces {
    /// Factory method: reads all workspaces from Sway and parses them
    pub fn read() -> Result<Self> {
        let mut conn = Connection::new()?;
        let workspaces = conn.get_workspaces()?;
        let items = workspaces
            .iter()
            .map(|ws| ContextAwareWorkspace::from(ws.name.as_str()))
            .collect();
        Ok(ContextAwareWorkspaces { items })
    }

    /// Return contexts filtered by starting letter
    pub fn filter_by_letter(&self, letter: char) -> Vec<String> {
        self.items
            .iter()
            .filter(|caw| {
                caw.context_name
                    .chars()
                    .next()
                    .map_or(false, |c| c.eq_ignore_ascii_case(&letter))
            })
            .map(|caw| caw.context_name.clone())
            .collect()
    }
}
