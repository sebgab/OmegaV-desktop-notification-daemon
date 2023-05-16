use reqwest;
use serde::Deserialize;
use serde_json;
use notify_rust::Notification;

#[derive(Debug, Deserialize)]
struct DoorResponseData {
    open: String,
    time: i64,
}

#[tokio::main]
async fn main() -> Result<(), reqwest::Error> {
    let mut prev_state: String = "".to_string();

    loop {
    let response = reqwest::get("https://omegav.no/api/dooropen.php")
        .await?
        .text()
        .await?;
    
    let door_response: DoorResponseData = serde_json::from_str(&response).unwrap();

    let notification_string: &str;

    if door_response.open != prev_state {
        if door_response.open == "1" {
            notification_string = "OmegaV is open!";
            prev_state = door_response.open;
        } else {
            notification_string = "OmegaV is closed!";
            prev_state = door_response.open;
        }

        let icon_path = format!("{}/.local/share/icons/hicolor/200x200/apps/OV.png", std::env::var("HOME").expect("Failed to get home directory"));

        Notification::new()
            .summary(notification_string)
            .image_path(&icon_path)
            .timeout(notify_rust::Timeout::Never)
            .show()
            .unwrap();
    }

    std::thread::sleep(std::time::Duration::new(30, 0));
    }
    Ok(())
}