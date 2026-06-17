$targetIP = "192.168.75.20"
$baseUrl  = "http://$targetIP"

# All pages to browse from our site 
$urls = @(
    "$baseUrl/", "$baseUrl/courses.html", "$baseUrl/events.html",
    "$baseUrl/services.html", "$baseUrl/ourstory.html", "$baseUrl/making-of.html"
)

# Real browser User-Agent strings — Chrome, Safari, Firefox to randomize
$userAgents = @(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) ... Chrome/120.0.0.0 ...",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ... Safari/605.1.15",
    "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) ... Firefox/115.0"
)

while ($true) {
    try {
        # Pick a random page and a random browser identity each request
        $url = $urls | Get-Random
        $ua  = $userAgents | Get-Random

        # Realistic browser headers to send
        $headers = @{
            "User-Agent"      = $ua
            "Accept"          = "text/html,application/xhtml+xml,*/*;q=0.8"
            "Accept-Language" = "en-US,en;q=0.5"
        }

        # Send GET request; -UseBasicParsing this skip the internet explorer to just do simpler parsing  
        $response = Invoke-WebRequest -Uri $url -Method Get -Headers $headers -TimeoutSec 5 -UseBasicParsing
        Write-Host "$(Get-Date) - [$url] Success: $($response.StatusCode)"
    }
    catch {
        Write-Host "$(Get-Date) - Failed: $_"
    }

    # Random pause between 1–3 seconds (simulates reading time)
    $thinkTime = Get-Random -Minimum 1 -Maximum 3
    Start-Sleep -Seconds $thinkTime
}