
# Log Monitoring and Alerting System

## Overview
This project is designed to monitor Linux log files for:
- Failed SSH login attempts
- Root login events
- Suspicious `sudo` misuse

If any of the conditions exceed a predefined threshold, the system sends a **Telegram** notification to the admin with detailed log information.

## Features
- Monitors `/var/log/secure` for login attempts and root logins.
- Detects abnormal `sudo` command usage.
- Sends real-time alerts via Telegram.

## Requirements
- **Linux Server** (CentOS/Ubuntu)
- **Telegram Bot** (for notifications)
- **curl** (for sending API requests)

## Installation

1. **Install required packages:**
   - CentOS/RHEL:  
     ```bash
     sudo yum install curl mailx -y
     ```
   - Ubuntu/Debian:  
     ```bash
     sudo apt install curl mailutils -y
     ```

2. **Create a Telegram Bot:**
   - Go to **@BotFather** on Telegram and follow instructions to create a bot.
   - Get your **Bot Token**.
   - Get your **Chat ID** using the following API request:  
     ```bash
     curl -s "https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates"
     ```

3. **Configure the Script:**
   - Download the script: `advanced_log_monitor.sh`
   - Update the script with your **Telegram Bot Token** and **Chat ID**.

4. **Set up Cron Job:**
   To run the script every 5 minutes, add it to the crontab:
   ```bash
   crontab -e
   ```
   Then add the following line:
   ```bash
   */5 * * * * /path/to/advanced_log_monitor.sh
   ```

## Usage
The script monitors `/var/log/secure` for the following:
- **Failed SSH login attempts**: Alerts if attempts exceed the set threshold.
- **Root logins**: Notifies when root logs in.
- **Sudo misuse**: Tracks and alerts for suspicious sudo attempts.

When any of these conditions are met, the script sends a notification to your Telegram chat.

## Example Telegram Notification
```text
[2025-05-14 17:24:10] 🔒 Security Alert on web-node

- Failed SSH attempts: 7
- Root login events: 2
- Suspicious sudo attempts: 1
```

## Cleanup
The script deletes temporary files after execution.

## Notes
- You can adjust the alert threshold by modifying the `ALERT_THRESHOLD` variable in the script.
- Make sure that your server has Internet access to send messages via Telegram.

## License
This project is open-source. Feel free to contribute or use it for your personal projects.
