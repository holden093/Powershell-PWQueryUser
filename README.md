README.md

# PWQueryUser Script

This PowerShell script checks for remote desktop sessions on specified servers and optionally logs off idle sessions for the current user.
I developed this in order to clean all of my sessions on the production server left hanging :-)

## Features:

- Connects to servers specified in a CSV file.
- Queries active Remote Desktop sessions for each server.
- Identifies the current user's sessions based on username.
- Logs off idle sessions exceeding a defined threshold.

## Requirements:

- PowerShell 5.1 or later

## Usage:

- Create a CSV file named computers.csv with a single column named "hostnames" containing the server names.
- Run the script: powershell -ExecutionPolicy Bypass -File PWQueryUser.ps1

## Options:

- None

## Output:

- The script displays information about active sessions on each server, including username, ID, and idle time.
- If enabled, the script logs off idle sessions exceeding 10 hours for the current user.

## Notes:

- The script requires elevated privileges (Run as administrator) to log off sessions.
- Modify the script to adjust the idle time threshold for logging off sessions.

## Additional Information:

- The script utilizes the quser command and logoff cmdlet for querying and logging off sessions, respectively.
- Error handling is not included but can be added for improved robustness.