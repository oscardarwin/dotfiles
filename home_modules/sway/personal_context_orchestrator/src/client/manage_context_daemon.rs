use anyhow::{anyhow, Result};
use serde::{Deserialize, Serialize};
use std::io::{BufRead, BufReader, Write};
use std::os::unix::net::UnixStream;

const SOCKET_PATH: &str = "/tmp/pcp.sock";

#[derive(Debug, Serialize, Deserialize)]
pub enum Request {
    SetContext(String),
    GetContext,
}

#[derive(Debug, Serialize, Deserialize)]
pub enum Response {
    Ok,
    Context(String),
    Error(String),
}

pub fn set_context(value: &str) -> Result<()> {
    let mut stream = UnixStream::connect(SOCKET_PATH)?;
    let req = serde_json::to_string(&Request::SetContext(value.to_string()))?;
    writeln!(stream, "{}", req)?;
    let mut reader = BufReader::new(&stream);
    let mut response = String::new();
    reader.read_line(&mut response)?;
    let resp: Response = serde_json::from_str(&response)?;
    match resp {
        Response::Ok => Ok(()),
        Response::Error(e) => Err(anyhow!(e)),
        Response::Context(_) => Ok(()),
    }
}

pub fn get_context() -> Result<String> {
    let mut stream = UnixStream::connect(SOCKET_PATH)?;
    let req = serde_json::to_string(&Request::GetContext)?;
    writeln!(stream, "{}", req)?;
    let mut reader = BufReader::new(&stream);
    let mut response = String::new();
    reader.read_line(&mut response)?;
    let resp: Response = serde_json::from_str(&response)?;
    match resp {
        Response::Context(c) => Ok(c),
        Response::Error(e) => Err(anyhow!(e)),
        Response::Ok => Err(anyhow!("Unexpected OK response")),
    }
}
