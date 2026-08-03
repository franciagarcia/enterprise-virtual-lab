$csvPath = "c:\lab-assets\newUsers.csv"
$domainDN = "DC=franlab,DC=org"

Import-Module ActiveDirectory

$users = Import-Csv -Path $csvPath

foreach ($user in $users){
        $samAccountName = ($user.FirstName + "." + $user. LastName). ToLower()
        $displayName = $user. FirstName + " " + $user. LastName
        $userPrincipalName = "$samAccountName@franlab.org"
        $targetOU = "OU=$($user.Department), $domainDN"
        $tempPassword = ConvertTo-SecureString "TempPass123!" -AsPlainText -Force

        #Define AD parameter splatting

                $userParams = @{

                GivenName = $user.FirstName
                Surname = $user.LastName                                                                                   
                Name  = $user.LastName
                DisplayName  = $displayName
                SamAccountName = $samAccountName
                UserPrincipalName = $userPrincipalName
                Path = $targetOU
                AccountPassword = $tempPassword
                ChangePasswordAtLogon = $true
                Enabled = $true

            }
        try {

                # 1. Create the user account
                Write-Host "Attempting to create user: $samAccountName ... " -ForegroundColor Cyan
                New-ADUser @userParams
                Write-Host "Success: Created $samAccountName" -ForegroundColor Green

        # 2. Assign to Primary Departmental Group (e.g., All-IT)
                if ($user.PrimaryGroup) {
                Add-ADGroupMember -Identity $user.PrimaryGroup -Members $samAccountName
                Write-Host " -> Add## 📸 Proof of Concept & Verification

Below is a side-by-side comparison of the Active Directory environment, showing manually created accounts versus the accounts dynamically generated and sorted by the PowerShell script.ed $samAccountName to grup: $($user.PrimaryGroup)" -ForegroundColor Cyan
                }
        # 3. Assign to Secondary Sub-Group (e.g., IT-Admin)
                if ($user.SubGroup) {
                Add-ADGroupMember -Identity $user. SubGroup -Members $samAccountName
                Write-Host " -> Added $samAccountName to group: $($user.SubGroup)" -ForegroundColor Cyan
                }
        }

catch {

Write-Warning "Failed to create user $samAccountName. Error: $_"
}
}