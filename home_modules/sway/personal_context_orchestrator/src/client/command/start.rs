use crate::context_workspace::{ContextWorkspace, ContextWorkspaces};
use crate::wofi;
use anyhow::Result;
use swayipc::Connection;

pub fn start() -> Result<()> {
    let starting_caw =
        ContextWorkspace::create_workspace_name(&"1".to_string(), &"default".to_string());

    let mut conn = Connection::new()?;
    conn.run_command(format!("workspace {}", starting_caw))?;

    Ok(())
}
