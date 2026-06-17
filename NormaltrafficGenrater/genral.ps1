while ($true) {

    # HTTP GET to port 80 — generates web traffic
    Invoke-WebRequest http://192.168.75.20/ -UseBasicParsing

    # ICMP ping — 5 packets; generates ping/echo traffic
    ping 192.168.75.20 -n 5

    # TCP connection check to port 445 (SMB/Windows file sharing)
    Test-NetConnection 192.168.75.20 -Port 445

    # TCP connection check to port 22 (SSH)
    Test-NetConnection 192.168.75.20 -Port 22

    # Wait 2 seconds before next round
    Start-Sleep -Seconds 2
}