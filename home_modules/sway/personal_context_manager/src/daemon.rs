use anyhow::Result;
use pcp::{Request, Response, State};
use std::fs;
use std::io::{BufRead, BufReader, Write};
use std::os::unix::net::{UnixListener, UnixStream};
use std::path::Path;

const SOCKET_PATH: &str = "/tmp/pcp.sock";

fn main() -> Result<()> {
    if Path::new(SOCKET_PATH).exists() {
        fs::remove_file(SOCKET_PATH)?;
    }

    let listener = UnixListener::bind(SOCKET_PATH)?;
    println!("Daemon listening on {}", SOCKET_PATH);

    let mut state = State::new();

    for stream in listener.incoming() {
        match stream {
            Ok(stream) => {
                if let Err(e) = handle_connection(stream, &mut state) {
                    eprintln!("Connection error: {:?}", e);
                }
            }
            Err(e) => eprintln!("Listener error: {:?}", e),
        }
    }

    Ok(())
}
fn handle_connection(mut stream: UnixStream, state: &mut State) -> Result<()> {
    let reader_stream = stream.try_clone()?; // clone for reading
    let reader = BufReader::new(reader_stream);

    for line in reader.lines() {
        let line = line?;
        let req: Request = serde_json::from_str(&line)?;
        let resp = state.handle(req);
        let resp_json = serde_json::to_string(&resp)?;
        writeln!(stream, "{}", resp_json)?;
    }

    Ok(())
}
