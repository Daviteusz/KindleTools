# Crash Logs Cleaner

## Description
Crash Logs Cleaner is a script designed to remove crash logs from the `/mnt/us/documents` folder on your device. It supports two log patterns: `KPPMainAppV2*` and `tmd_*`. The script can be executed from both KOReader and KUAL interfaces.

## How It Works
The script searches and deletes log files in `.txt`, `.tgz` formats, and `.sdr` folders matching the specified name patterns. After completing the process, it displays a message indicating the operation's outcome.

## Installation Steps
1. Place the `CrashLogsCleaner` folder in `/mnt/us/extensions`.

## Usage
### Using with KUAL
1. Open KUAL.
2. Select "CrashLogs Cleaner".
3. Choose "Remove Crash Logs".

### Using with KOReader
Using with KOReader
1. Launch KOReader, navigate to (Tools icon) > More Tools > Terminal Emulator > Start Terminal Session
2. Click menu button "=" > Create new alias:
Name:
clear_logs
Command:
/mnt/us/extensions/CrashLogsCleaner/bin/crash_logs_cleaner.sh --koreader.
3. Execute!

Alias will be saved in this menu for future use.

You can also manually run the script using the following command:
```sh
sh /mnt/us/extensions/CrashLogsCleaner/bin/crash_logs_cleaner.sh --koreader
```
