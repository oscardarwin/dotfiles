use serde::{Deserialize, Serialize};

/// All requests the client can send.
#[derive(Debug, Serialize, Deserialize)]
pub enum Request {
    SetContext(String),
    GetContext,
}

/// All responses the daemon can send.
#[derive(Debug, Serialize, Deserialize)]
pub enum Response {
    Ok,
    Context(String),
    Error(String),
}

/// Synchronous in-memory state for the daemon.
#[derive(Debug, Default)]
pub struct State {
    pub context: String,
}

impl State {
    pub fn new() -> Self {
        Self {
            context: "default".to_string(),
        }
    }

    pub fn handle(&mut self, req: Request) -> Response {
        match req {
            Request::SetContext(ctx) => {
                self.context = ctx;
                Response::Ok
            }
            Request::GetContext => Response::Context(self.context.clone()),
        }
    }
}
