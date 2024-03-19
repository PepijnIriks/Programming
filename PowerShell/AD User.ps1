# Vraag de gebruiker om invoer van accountgegevens
$username = Read-Host -Prompt "Voer de gebruikersnaam in"
$firstName = Read-Host -Prompt "Voer de voornaam in"
$lastName = Read-Host -Prompt "Voer de achternaam in"
$password = Read-Host -Prompt "Voer het wachtwoord in" -AsSecureString

# Bestandslocatie waar de accountgegevens tijdelijk worden opgeslagen
$dataFile = "C:\ADUsers\ADAccounts.txt"

# Functie om het wachtwoord te valideren
function Validate-Password {
    param (
        [Security.SecureString]$passwordSecure
    )

    $password = [Net.NetworkCredential]::new("", $passwordSecure).Password
    $isValid = $password.Length -ge 6 -and $password -match '\d'

    if (-not $isValid) {
        throw "Het wachtwoord moet minstens 6 karakters lang zijn en ten minste één cijfer bevatten."
    }
}

# Wachtwoordvalidatie en invoer
do {
    $password = Read-Host -Prompt "Voer het wachtwoord in" -AsSecureString
    try {
        Validate-Password -passwordSecure $password
        $isValid = $true
    } catch {
        Write-Warning $_.Exception.Message
        $isValid = $false
    }
} while (-not $isValid)

# Functie om de invoergegevens in het tekstbestand op te slaan
function Save-InputData {
    $userData = "Gebruikersnaam: $username, Voornaam: $firstName, Achternaam: $lastName"
    Add-Content -Path $dataFile -Value $userData
}

# Opslaan van de invoergegevens
Save-InputData

# Bevestiging naar de gebruiker
Write-Host "De gebruiker $username is succesvol aangemaakt en opgeslagen in $dataFile"
