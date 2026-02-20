use anyhow::Result;
use serde::Serialize;
use swayipc::Connection;

pub type WorkspaceName = String;
pub type ContextName = String;

#[derive(Clone, PartialEq, Eq, PartialOrd, Ord, Serialize)]
pub struct ContextAwareWorkspace {
    pub workspace_display_name: String,
    pub context_name: ContextName,
    pub associated_char: char,
}

#[derive(Debug)]
pub enum ContextAwareWorkspaceCreationError {
    MissingSeparator,
    EmptyContextName,
    EmptyWorkspaceDisplayName,
}

impl ContextAwareWorkspace {
    pub fn new(
        workspace_display_name: WorkspaceName,
        context_name: ContextName,
    ) -> Result<ContextAwareWorkspace, ContextAwareWorkspaceCreationError> {
        let Some(associated_char) = workspace_display_name.chars().next() else {
            return Err(ContextAwareWorkspaceCreationError::EmptyWorkspaceDisplayName);
        };
        Ok(Self {
            context_name,
            workspace_display_name,
            associated_char,
        })
    }
}

impl TryFrom<&str> for ContextAwareWorkspace {
    type Error = ContextAwareWorkspaceCreationError;

    fn try_from(s: &str) -> Result<Self, Self::Error> {
        let mut parts = s.splitn(2, ':');

        let context_name = parts
            .next()
            .ok_or(ContextAwareWorkspaceCreationError::MissingSeparator)?
            .to_string();

        let workspace_display_name = parts
            .next()
            .ok_or(ContextAwareWorkspaceCreationError::MissingSeparator)?
            .to_string();

        if context_name.is_empty() {
            return Err(ContextAwareWorkspaceCreationError::EmptyContextName);
        }

        ContextAwareWorkspace::new(workspace_display_name, context_name)
    }
}

impl From<ContextAwareWorkspace> for WorkspaceName {
    fn from(caw: ContextAwareWorkspace) -> Self {
        ContextAwareWorkspace::create_workspace_name(&caw.workspace_display_name, &caw.context_name)
    }
}

impl ContextAwareWorkspace {
    pub fn first_letter_of_workspace_matches(&self, letter: &char) -> bool {
        letter.eq_ignore_ascii_case(&self.associated_char)
    }

    pub fn create_workspace_name(
        workspace_display_name: &String,
        context_name: &ContextName,
    ) -> String {
        format!("{}:{}", context_name, workspace_display_name)
    }
}

#[derive(Clone)]
pub struct ContextAwareWorkspaces {
    pub items: Vec<ContextAwareWorkspace>,
}

impl ContextAwareWorkspaces {
    pub fn read() -> Result<Self> {
        let mut conn = Connection::new()?;
        let workspaces = conn.get_workspaces()?;
        let items = workspaces
            .iter()
            .filter_map(|ws| ContextAwareWorkspace::try_from(ws.name.as_str()).ok())
            .collect();
        Ok(ContextAwareWorkspaces { items })
    }
}
