use anyhow::Result;
use swayipc::Connection;

fn matches_first_letter(word: &String, letter: &char) -> bool {
    word.chars()
        .next()
        .map_or(false, |c| c.eq_ignore_ascii_case(letter))
}

pub type WorkspaceName = String;

#[derive(Clone, PartialEq, Eq, PartialOrd, Ord)]
pub struct ContextAwareWorkspace {
    pub workspace_display_name: String,
    pub context_name: String,
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

impl ContextAwareWorkspace {
    pub fn first_letter_of_workspace_matches(&self, letter: &char) -> bool {
        matches_first_letter(&self.workspace_display_name, letter)
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
            .map(|ws| ContextAwareWorkspace::from(ws.name.as_str()))
            .collect();
        Ok(ContextAwareWorkspaces { items })
    }

    pub fn filter_by_context_first_letter(&self, letter: char) -> Vec<String> {
        self.items
            .iter()
            .filter(|caw| matches_first_letter(&caw.context_name, &letter))
            .map(|caw| caw.context_name.clone())
            .collect()
    }
}
