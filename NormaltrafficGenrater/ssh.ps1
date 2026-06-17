$host_ip  = "192.168.75.20"
$user     = "ADMINISTRATOR"
$password = "P@ssw0rd"

# Pool of commands that a real sysadmin might run over SSH
$commands = @(
    "hostname",                               # Get machine name
    "whoami",                                 # Get current user
    "systeminfo | findstr /B /C:'OS'",        # OS version only
    "ipconfig",                               # Network interfaces
    "tasklist | findstr svchost"              # Filter process list
)

while ($true) {
    try {
        # Randomly run 2–5 commands per "session"
        $sessionCmds = Get-Random -Minimum 2 -Maximum 6
        for ($i = 0; $i -lt $sessionCmds; $i++) {

            $cmd = $commands | Get-Random

            # plink: PuTTY CLI SSH client; -batch disables interactive prompts
            plink -batch -ssh $host_ip -l $user -pw $password $cmd
            Write-Host "$(Get-Date) - Ran: $cmd"

            # Short pause between commands in the same session
            Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 4)
        }

        # gap between sessions to mimics a human stepping away
        Start-Sleep -Seconds (Get-Random -Minimum 8 -Maximum 15)
    }
    catch {
        Write-Host "$(Get-Date) - Failed: $_"
        Start-Sleep -Seconds 10
    }
}