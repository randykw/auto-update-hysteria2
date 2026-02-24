# Auto Update Hysteria2

A script to automatically check and update Hysteria2 to the latest version on Ubuntu/Debian servers.

## Features

- Compares current version with the latest release on GitHub
- Skips update if already up to date
- Supports x86_64 and arm64 architectures
- Logs update history to `/var/log/hysteria2-update.log`

## Download

Using `curl`:

```bash
curl -sL -o update-hysteria2.sh https://raw.githubusercontent.com/randykw/auto-update-hysteria2/main/update-hysteria2.sh
chmod +x update-hysteria2.sh
```

Or using `wget`:

```bash
wget -O update-hysteria2.sh https://raw.githubusercontent.com/randykw/auto-update-hysteria2/main/update-hysteria2.sh
chmod +x update-hysteria2.sh
```

## Usage

Run manually:

```bash
sudo ./update-hysteria2.sh
```

Set up a cron job to check for updates daily at 3:00 AM:

```bash
sudo crontab -e
```

Add the following line:

```
0 3 * * * /path/to/update-hysteria2.sh
```

## Configuration

Edit the variables in the script as needed:

| Variable | Default | Description |
|----------|---------|-------------|
| `SERVICE_NAME` | `hysteria-server` | systemd service name |
| `INSTALL_DIR` | `/usr/local/bin` | Installation directory |
| `LOG` | `/var/log/hysteria2-update.log` | Log file path |
