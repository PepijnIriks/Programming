# Importeer de Active Directory-module
Import-Module ActiveDirectory
 
# Vraag de gebruiker om invoer van accountgegevens
$username = Read-Host -Prompt "Voer de gebruikersnaam in"
$firstName = Read-Host -Prompt "Voer de voornaam in"
$lastName = Read-Host -Prompt "Voer de achternaam in"
$passwordSecure = Read-Host -Prompt "Voer het wachtwoord in" -AsSecureString
 
# Vraag de gebruiker om de naam van de OU
$ouName = Read-Host -Prompt "Voer de naam van de organisatie-eenheid (OU) in waarin de gebruiker aangemaakt moet worden"
 
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
    try {
        Validate-Password -passwordSecure $passwordSecure
        $isValid = $true
    } catch {
        Write-Warning $_.Exception.Message
        $passwordSecure = Read-Host -Prompt "Voer het wachtwoord in" -AsSecureString
        $isValid = $false
    }
} while (-not $isValid)
 
# Functie om de OU te controleren en aan te maken indien nodig
function Ensure-OU {
    param (
        [string]$ouName
    )
    
    $ouPath = "OU=$ouName,$((Get-ADDomain).DistinguishedName)"
    
    if (-not (Get-ADOrganizationalUnit -Filter { Name -eq $ouName } -ErrorAction SilentlyContinue)) {
        # OU bestaat niet, maak het aan
        New-ADOrganizationalUnit -Name $ouName -Path ((Get-ADDomain).DistinguishedName) -ProtectedFromAccidentalDeletion $false
        Write-Host "OU '$ouName' is gecreëerd."
    } else {
        Write-Host "OU '$ouName' bestaat al."
    }
    
    return $ouPath
}
 
# Functie om de gebruiker aan te maken in Active Directory
function Create-ADUser {
    param (
        [string]$username,
        [string]$firstName,
        [string]$lastName,
        [Security.SecureString]$passwordSecure,
        [string]$ouPath
    )
 
    # Converteer het beveiligde wachtwoord naar een tekst wachtwoord
    $password = [Net.NetworkCredential]::new("", $passwordSecure).Password
    
    # Maak het nieuwe AD-gebruikersaccount
    New-ADUser -Name "$firstName $lastName" -GivenName $firstName -Surname $lastName -SamAccountName $username -UserPrincipalName "$username@$((Get-ADDomain).DNSRoot)" -Path $ouPath -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true
}
 
# Zorg ervoor dat de OU bestaat en maak deze indien nodig aan
$ouPath = Ensure-OU -ouName $ouName
 
# Creëer de AD-gebruiker in de specifieke OU
Create-ADUser -username $username -firstName $firstName -lastName $lastName -passwordSecure $passwordSecure -ouPath $ouPath
 
# Bevestiging naar de gebruiker
Write-Host "De gebruiker $username is succesvol aangemaakt in OU '$ouName' in Active Directory."
