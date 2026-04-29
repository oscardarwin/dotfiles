use std::collections::HashMap;

use anyhow::{anyhow, Result};
use swayipc::Connection;

pub fn switch_to_output(id: usize) -> Result<()> {
    let mut conn = Connection::new()?;

    let outputs = conn
        .get_outputs()?
        .into_iter()
        .enumerate()
        .map(|(index, output)| (index + 1, output.name.clone()))
        .collect::<HashMap<usize, String>>();

    let output_name = outputs
        .get(&id)
        .ok_or(anyhow!("Could not find output with id {}", id))?;

    conn.run_command(format!("focus output {}", output_name))?;

    Ok(())
}
