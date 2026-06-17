# How many unique destination filenames to cycle through
$maxFiles = 10
$counter  = 0

while ($true) {
    try {
        # Modulo keeps the index between 0-9, cycling files instead of growing disk
        $fileIndex   = $counter % $maxFiles

        #  path to the SMB share on the target server
        $destination = "\\192.168.75.20\test\testfile_$fileIndex.txt"

        # Copy a local file to the share; -Force overwrites if it exists
        Copy-Item "C:\Users\vboxuser\Desktop\test\testfile.txt" $destination -Force
        Write-Host "$(Get-Date) - Copied testfile_$fileIndex.txt"

        $counter++  # Advance to next filename
    }
    catch {
        Write-Host "Copy failed: $_"
    }

    # Random 2–4 second pause between file transfers
    Start-Sleep -Seconds (Get-Random -Minimum 2 -Maximum 4)
}