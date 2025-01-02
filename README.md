# Pulse - Simple Monitoring App

`pulse.sh` is a lightweight, bash-based monitoring application designed to keep track of server health metrics, such as CPU load, storage usage, and other system resources.

It sends alerts when defined thresholds are exceeded, helping you proactively manage your server.

---

## Features

- **CPU Monitoring**: Alerts when CPU load exceeds a specified threshold.
- **Storage Monitoring**: Sends warnings when disk usage crosses the defined limit.
- **Customizable Thresholds**: Easily adjust the alert limits for CPU and storage.
- **Notification Support**: Integrates with Telegram or other messaging services to deliver real-time alerts.
- **Lightweight**: Built entirely in Bash, making it easy to deploy without additional dependencies.

---

## Requirements

- **Supported Commands**: Ensure the system supports `uptime`, `df`, `free`, and other common Unix commands.
- **Network Access**: (Optional) Required for Telegram notifications.

---

## Installation

1. Clone the repository to your server:
   ```bash
   git clone https://github.com/usmonaliyev/pulse.git
   cd pulse
   ```
2. Run `install.sh` file.

   ```bash
   chmod +x install.sh
   ./install.sh
   ```
