use futures_util::StreamExt;
use indexmap::IndexMap;
use serde::Serialize;
use std::collections::HashMap;
use zbus::zvariant::{OwnedObjectPath, OwnedValue};
use zbus::{Connection, MatchRule, MessageStream, Proxy};

#[derive(Serialize, Clone)]
struct ServiceInformation {
    service_name: &'static str,
    icon: char,
}

impl ServiceInformation {
    const fn new(service_name: &'static str, icon: char) -> Self {
        Self { service_name, icon }
    }
}

#[derive(Serialize, Clone, PartialEq)]
struct UnitState {
    active: String,
    result: String,
    nrestarts: u32,
}

#[derive(Serialize, Clone)]
struct ServiceStatus {
    service_information: ServiceInformation,
    unit_state: UnitState,
}

const MONITORED_SERVICES: &[ServiceInformation] = &[
    ServiceInformation::new("keyboard-monitor.service", ''),
];

async fn get_service_statuses(
    connection: &Connection,
) -> zbus::Result<IndexMap<String, ServiceStatus>> {
    let manager = Proxy::new(
        connection,
        "org.freedesktop.systemd1",
        "/org/freedesktop/systemd1",
        "org.freedesktop.systemd1.Manager",
    )
    .await?;

    manager.call_noreply("Subscribe", &()).await?;

    let mut map = IndexMap::new();
    for svc in MONITORED_SERVICES {
        let path: OwnedObjectPath = manager.call("LoadUnit", &(svc.service_name)).await?;

        let unit_proxy = Proxy::new(
            connection,
            "org.freedesktop.systemd1",
            path.as_str(),
            "org.freedesktop.systemd1.Unit",
        )
        .await?;

        let service_proxy = Proxy::new(
            connection,
            "org.freedesktop.systemd1",
            path.as_str(),
            "org.freedesktop.systemd1.Service",
        )
        .await?;

        let state = UnitState {
            active: unit_proxy.get_property("ActiveState").await?,
            result: service_proxy
                .get_property("Result")
                .await
                .unwrap_or_else(|_| "unknown".to_string()),
            nrestarts: service_proxy.get_property("NRestarts").await.unwrap_or(0),
        };

        map.insert(
            String::from(path.as_str()),
            ServiceStatus {
                service_information: svc.clone(),
                unit_state: state,
            },
        );
    }

    Ok(map)
}

async fn handle_signal(
    object_path: &str,
    changed: HashMap<String, OwnedValue>,
    services: &mut IndexMap<String, ServiceStatus>,
) -> bool {
    let svc = match services.get_mut(object_path) {
        Some(s) => s,
        None => return false,
    };

    let previous_state = svc.unit_state.clone();

    for (key, value) in changed {
        match key.as_str() {
            "ActiveState" => {
                if let Ok(s) = <String>::try_from(value) {
                    svc.unit_state.active = s;
                }
            }
            "Result" => {
                if let Ok(s) = <String>::try_from(value) {
                    svc.unit_state.result = s;
                }
            }
            "NRestarts" => {
                if let Ok(v) = <u32>::try_from(value) {
                    svc.unit_state.nrestarts = v;
                }
            }
            _ => {}
        }
    }

    svc.unit_state != previous_state
}

#[tokio::main]
async fn main() -> zbus::Result<()> {
    let connection = Connection::session().await?;

    let mut services = get_service_statuses(&connection).await?;
    print_json(&services);

    let rule = MatchRule::builder()
        .msg_type(zbus::message::Type::Signal)
        .sender("org.freedesktop.systemd1")?
        .interface("org.freedesktop.DBus.Properties")?
        .member("PropertiesChanged")?
        .build();

    let rule = MatchRule::builder()
        .msg_type(zbus::message::Type::Signal)
        .sender("org.freedesktop.systemd1")?
        .build();

    let mut stream = MessageStream::for_match_rule(rule, &connection, None).await?;

    while let Some(msg) = stream.next().await {
        let msg = msg?;

        let object_path = match msg.header().path() {
            Some(p) => p.to_string(),
            None => continue,
        };

        let (_, changed, _): (String, HashMap<String, OwnedValue>, Vec<String>) =
            match msg.body().deserialize() {
                Ok(v) => v,
                Err(_) => continue,
            };

        if handle_signal(&object_path, changed, &mut services).await {
            print_json(&services);
        }
    }
    Ok(())
}

fn print_json(map: &IndexMap<String, ServiceStatus>) {
    let output: Vec<ServiceStatus> = map.values().cloned().collect();
    println!("{}", serde_json::to_string(&output).unwrap());
}
