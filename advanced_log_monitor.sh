#!/bin/bash

# Configuration
LOG_FILE="/var/log/secure"  # Use /var/log/auth.log for Ubuntu
ALERT_THRESHOLD=5
TMP_FAILED="/tmp/failed_login_check.txt"
TMP_ALERT="/tmp/log_alert.txt"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname)

# Telegram Bot Config
TELEGRAM_BOT_TOKEN="your_bot_token"
TELEGRAM_CHAT_ID="your_chat_id"
TELEGRAM_API="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"

# Detect Failed SSH Logins
grep "Failed password" $LOG_FILE | grep "$(date '+%b %_d')" > $TMP_FAILED
FAILED_COUNT=$(wc -l < $TMP_FAILED)

# Detect Root Logins
ROOT_LOGINS=$(grep "session opened for user root" $LOG_FILE | grep "$(date '+%b %_d')" | wc -l)

# Detect Sudo Misuse
SUDO_ALERTS=$(grep "sudo" /var/log/secure | grep "$(date '+%b %_d')" | grep -v "COMMAND=" | wc -l)

# Build Alert Message
ALERT_MSG="[$DATE] 🔒 Security Alert on $HOSTNAME

- Failed SSH attempts: $FAILED_COUNT
- Root login events: $ROOT_LOGINS
- Suspicious sudo attempts: $SUDO_ALERTS"

# Conditional Alert Trigger
if [ "$FAILED_COUNT" -gt "$ALERT_THRESHOLD" ] || [ "$ROOT_LOGINS" -gt 0 ] || [ "$SUDO_ALERTS" -gt 0 ]; then
    echo "$ALERT_MSG" > $TMP_ALERT

    # Send Alert via Telegram
    curl -s -X POST $TELEGRAM_API -d chat_id="$TELEGRAM_CHAT_ID" -d text="$ALERT_MSG"
fi

# Cleanup
rm -f $TMP_FAILED $TMP_ALERT
