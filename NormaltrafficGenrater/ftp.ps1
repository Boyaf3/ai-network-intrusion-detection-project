
#Trarget FTP server IP address
$host_ip = "192.168.75.20"

# multiple users credentials that is already created in the server
$users = @(
    @{user="ADMINISTRATOR"; pass="P@ssw0rd"},
    @{user="ftpuser";     pass="P@ssw0rd"},
    @{user="anonymous";   pass=""}          
)

# Infinite loop for traffic 
while ($true) {
    try {
        # Pick a random account each session
        $account = $users | Get-Random

        # Build the FTP request (ListDirectory)
        $ftp = [System.Net.FtpWebRequest]::Create("ftp://$host_ip/")
        $ftp.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectory
        $ftp.Credentials = New-Object System.Net.NetworkCredential($account.user, $account.pass)
        $ftp.UsePassive = $true   # Client opens data channel (firewall-friendly)
        $ftp.UseBinary  = $true   
        $ftp.KeepAlive  = $false  # Close connection after each request

        $response = $ftp.GetResponse()
        $response.Close()  # Always release the connection

        Write-Host "$(Get-Date) - FTP session as $($account.user) success"
        Start-Sleep -Seconds (Get-Random -Minimum 2 -Maximum 4)
    }
    catch {
        # Log the error and wait before retrying
        Write-Host "$(Get-Date) - Failed: $_"
        Start-Sleep -Seconds 5
    }

    # Extra random delay between sessions
    $break = Get-Random -Minimum 1 -Maximum 3
    Start-Sleep -Seconds $break
}
