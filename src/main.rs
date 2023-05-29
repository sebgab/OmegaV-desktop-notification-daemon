#![cfg_attr(all(target_os="windows", not(feature = "console"),), windows_subsystem = "windows")]

use reqwest;
use serde::Deserialize;
use serde_json;
use notify_rust::Notification;
use tokio::time::{Duration, Instant};

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
    // Get the icon path for the notification. (Only linux supports icons, so we only get the proper path on linux.)
    let icon_path;
    #[cfg(target_os = "linux")] {
    icon_path = format!("{}/.local/share/icons/hicolor/200x200/apps/OV.png", std::env::var("HOME").expect("Failed to get home directory"));
    }
    #[cfg(not(target_os = "linux"))] {
    icon_path = "".to_string();
    }

    // Fire off the notification
    let notification = Notification::new()
        .summary(notification_string)
        .image_path(&icon_path)
        .timeout(notify_rust::Timeout::Never)
        .show();


    match notification {
        Ok(_) => {}, // Do nothing upon successfully sending a notification
        Err(e) => {
            eprintln!("Failed to send notification with error: {:?}", e);
        }
    }
}

#[tokio::main]
async fn main() {
    let mut prev_state: String = "".to_string(); // String to store the previous state, used to detect a state change.

    // Quick refresh config
    let quick_refresh_duration: Duration = Duration::from_secs(60);

    let default_refresh_delay: u64 = 60;
    let quick_refresh_delay: u64 = 15;
    let mut refresh_delay: u64 = default_refresh_delay; // The time between API calls

    // Quick refresh stuff
    let mut quick_refresh_mode: bool = false;
    let mut quick_refresh_end_time: Instant = Instant::now();

    loop {
    // Get the door state
    let http_response = get_door_data().await;
    let response;

    // If the response is ok, store the data. If not skip and retry later.
    match http_response {
        Ok(data) => { response = data; },
        Err(e) => {
            // If we get a network error, wait and try again
            eprintln!("Getting the door status failed with error: {:?}", e);
            std::thread::sleep(std::time::Duration::new(5, 0));
            continue;
        }
    }

    // Parse the JSON
    let door_response: DoorResponseData;
    match serde_json::from_str(&response) {
        Ok(response) => { door_response = response; },
        Err(e) => { eprintln!("Failed to parse door resonse data with error: {:?}", e); continue; }
    }

    // Create a string to hold our output message.
    let notification_string: &str;

    // If the door state changed
    if door_response.open != prev_state {

        // Create an appropriate message based on the door state
        if door_response.open == "1" {
            notification_string = "OmegaV is open!";
            prev_state = door_response.open;

            // Reset quick_refresh stuff
            quick_refresh_mode = true;                                                      // Enable the quick refresh
            quick_refresh_end_time = Instant::now() + quick_refresh_duration;               // Update the end time variable
            refresh_delay = quick_refresh_delay;                                            // Set the new refresh delay
        } else {
            notification_string = "OmegaV is closed!";
            prev_state = door_response.open;

            quick_refresh_end_time = Instant::now(); // Disable the quick refresh when the door closes
        }

        // Fire off a notification to the user
        send_notification(notification_string).await;
    }

    // Sometimes the door quickly opens and closes, to notify people that this is the case the refresh period is shortened after the door opens.
    if quick_refresh_mode && Instant::now() >= quick_refresh_end_time {
        quick_refresh_mode = false;
        refresh_delay = default_refresh_delay;
    }

    // Wait for a given period before the next API call
    std::thread::sleep(std::time::Duration::new(refresh_delay, 0));
    }
}