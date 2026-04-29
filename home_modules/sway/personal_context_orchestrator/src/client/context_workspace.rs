use std::collections::BTreeSet;

use anyhow::anyhow;
use anyhow::Result;
use serde::Serialize;
use swayipc::{Connection, Workspace};

pub type WorkspaceName = String;
pub type ContextName = String;

#[derive(Serialize, Eq, Ord, Debug, PartialEq, PartialOrd, Clone)]
pub struct Context {
    pub associated_char: char,
    pub name: String,
}

struct EmptyNameError;

impl Context {
    pub fn new(name: String) -> Result<Context, EmptyNameError> {
        let Some(associated_char) = name.chars().next() else {
            return Err(EmptyNameError);
        };

        Ok(Self {
            associated_char,
            name,
        })
    }
}

#[derive(Serialize, Eq, Debug, Ord, PartialEq, PartialOrd, Clone)]
pub struct Output {
    pub device: String,
    pub name: String,
}

impl Output {
    pub fn new(name: String, device: String) -> Output {
        Self { device, name }
    }
}

#[derive(Serialize, Debug, Eq, Ord, PartialEq, PartialOrd, Clone)]
pub struct Space {
    pub associated_char: char,
    pub name: String,
}

impl Space {
    pub fn new(name: String) -> Result<Space, EmptyNameError> {
        let Some(associated_char) = name.chars().next() else {
            return Err(EmptyNameError);
        };
        Ok(Self {
            associated_char,
            name,
        })
    }
}

#[derive(Clone, Debug, PartialEq, Eq, PartialOrd, Ord, Serialize)]
pub struct ContextWorkspace {
    pub context: Context,
    pub space: Space,
    pub output: String,
    pub focused: bool,
    pub visible: bool,
}

#[derive(Debug)]
pub enum ContextWorkspaceCreationError {
    MissingSeparator,
    EmptyContextName,
    EmptyWorkspaceDisplayName,
}

impl ContextWorkspace {
    pub fn new(
        workspace_display_name: WorkspaceName,
        context_name: ContextName,
        output: String,
        focused: bool,
        visible: bool,
    ) -> Result<ContextWorkspace, ContextWorkspaceCreationError> {
        let context = Context::new(context_name)
            .map_err(|_| ContextWorkspaceCreationError::EmptyContextName)?;

        let space = Space::new(workspace_display_name)
            .map_err(|_| ContextWorkspaceCreationError::EmptyWorkspaceDisplayName)?;

        Ok(Self {
            context,
            space,
            output,
            focused,
            visible,
        })
    }
}

impl TryFrom<&Workspace> for ContextWorkspace {
    type Error = ContextWorkspaceCreationError;

    fn try_from(workspace: &Workspace) -> Result<Self, Self::Error> {
        let mut parts = workspace.name.splitn(3, ':');

        let context_name = parts
            .next()
            .ok_or(ContextWorkspaceCreationError::MissingSeparator)?
            .to_string();

        let workspace_display_name = parts
            .next()
            .ok_or(ContextWorkspaceCreationError::MissingSeparator)?
            .to_string();

        ContextWorkspace::new(
            workspace_display_name,
            context_name,
            workspace.output.clone(),
            workspace.focused,
            workspace.visible,
        )
    }
}

impl From<&ContextWorkspace> for WorkspaceName {
    fn from(caw: &ContextWorkspace) -> Self {
        ContextWorkspace::create_workspace_name(&caw.space.name, &caw.context.name)
    }
}

impl ContextWorkspace {
    pub fn first_letter_of_workspace_matches(&self, letter: &char) -> bool {
        letter.eq_ignore_ascii_case(&self.space.associated_char)
    }

    pub fn create_workspace_name(
        workspace_display_name: &WorkspaceName,
        context_name: &ContextName,
    ) -> String {
        format!("{}:{}", context_name, workspace_display_name)
    }
}

#[derive(Clone)]
pub struct ContextWorkspaces {
    pub items: Vec<ContextWorkspace>,
}

impl ContextWorkspaces {
    pub fn read() -> Result<Self> {
        let mut conn = Connection::new()?;
        let workspaces = conn.get_workspaces()?;
        let items = workspaces
            .iter()
            .filter_map(|ws| ContextWorkspace::try_from(ws).ok())
            .collect();
        Ok(ContextWorkspaces { items })
    }

    fn matches_first_letter(word: &String, letter: &char) -> bool {
        word.chars()
            .next()
            .map_or(false, |c| c.eq_ignore_ascii_case(letter))
    }

    pub fn filter_by_context_first_letter(&self, letter: char) -> Vec<ContextName> {
        let deduplicated: BTreeSet<_> = self
            .items
            .iter()
            .filter(|caw| Self::matches_first_letter(&caw.context.name, &letter))
            .map(|caw| caw.context.name.clone())
            .collect();

        deduplicated.into_iter().collect()
    }

    pub fn get_focused(&self) -> Result<&ContextWorkspace> {
        self.items
            .iter()
            .find(|cw| cw.focused)
            .ok_or_else(|| anyhow!("no focused workspace"))
    }
}
