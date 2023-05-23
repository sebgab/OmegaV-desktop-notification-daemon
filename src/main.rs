#![cfg_attr(all(target_os="windows", not(feature = "console"),), windows_subsystem = "windows")]

use reqwest;
use serde::Deserialize;
use serde_json;
use notify_rust::Notification;

#[derive(Debug, Deserialize)]
struct DoorResponseData {
    open: String,
}

// Querie the OmegaV server to see if the door is open
async fn get_door_data() -> Result<String, reqwest::Error> {
    let response = reqwest::get("https://omegav.no/api/dooropen.php")
        .await?
        .text()
        .await?;

    Ok(response)
}

// Notification function
async fn send_notification(notification_string: &str) {
    // Get the icon path for the notification
    let mut icon_path: String = "".to_string();
    #[cfg(target_os = "linux")] {
    icon_path = format!("{}/.local/share/icons/hicolor/200x200/apps/OV.png", std::env::var("HOME").expect("Failed to get home directory"));
    }

    // Fire off the notification
    Notification::new()
        .summary(notification_string)
        .image_path(&icon_path)
        .timeout(notify_rust::Timeout::Never)
        .show()
        .unwrap();
}


#[tokio::main]
async fn main() -> Result<(), reqwest::Error> {
    let mut prev_state: String = "".to_string();

    loop {
    // Get the door state
    let http_response = get_door_data().await;

    // If we get a network error, wait and try again
    if http_response.is_err() {
        println!("Getting the door status failed with error: {:?}", http_response.err());
        std::thread::sleep(std::time::Duration::new(5, 0));
        continue;
    } 

    // Get the result of the http request
    let response = http_response.unwrap();
    // Parse the JSON
    let door_response: DoorResponseData = serde_json::from_str(&response).unwrap();

    // Create a string to hold our output message.
    let notification_string: &str;

    // If the door state changed
    if door_response.open != prev_state {

        // Create an appropriate message based on the door state
        if door_response.open == "1" {
            notification_string = "OmegaV is open!";
            prev_state = door_response.open;
        } else {
            notification_string = "OmegaV is closed!";
            prev_state = door_response.open;
        }

        // Fire off a notification to the user
        send_notification(notification_string).await;
    }

    // Do a check every 15 seconds
    std::thread::sleep(std::time::Duration::new(15, 0));
    }
}