use serde::Serialize;
use std::process::Command;

#[derive(Serialize)]
struct WaybarOutput {
    text: String,
    class: String,
    tooltip: String,
}

fn main() {
    let services = [
        "pipewire.service",
        "wireplumber.service",
        "swayidle.service",
        "keyboard-monitor.service",
    ];

    let mut bad = false;
    let mut warn = false;
    let mut tooltip_lines = vec!["Service status:".to_string()];

    for svc in &services {
        // Run systemctl to get properties
        let output = Command::new("systemctl")
            .args(&["--user", "show", svc, "--property=ActiveState,SubState,NRestarts,Result", "--no-pager"])
            .output();

        let props = match output {
            Ok(out) => String::from_utf8_lossy(&out.stdout).to_string(),
            Err(_) => "".to_string(),
        };

        let mut active = "unknown";
        let mut sub = "unknown";
        let mut nrestarts = 0;
        let mut result = "";

        for line in props.lines() {
            if let Some(pos) = line.find('=') {
                let (key, value) = line.split_at(pos);
                let value = &value[1..]; // skip '='
                match key {
                    "ActiveState" => active = value,
                    "SubState" => sub = value,
                    "NRestarts" => nrestarts = value.parse::<u32>().unwrap_or(0),
                    "Result" => result = value,
                    _ => {}
                }
            }
        }

        tooltip_lines.push(format!("{}:", svc));
        tooltip_lines.push(format!("  ActiveState={}", active));
        tooltip_lines.push(format!("  SubState={}", sub));
        tooltip_lines.push(format!("  Restarts={}", nrestarts));

        if active != "active" {
            warn = true;
        }
        if nrestarts >= 5 || result == "start-limit-hit" {
            bad = true;
        }
    }

    // Determine icon and class
    let (icon, class) = if bad {
        ("", "critical")
    } else if warn {
        ("", "warning")
    } else {
        ("", "ok")
    };

    let output = WaybarOutput {
        text: icon.to_string(),
        class: class.to_string(),
        tooltip: tooltip_lines.join("\n"),
    };

    // Print JSON
    println!("{}", serde_json::to_string(&output).unwrap());
}
