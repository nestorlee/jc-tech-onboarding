$StringPassword = "P@ssw0rd123"
$SecureAdminSafeModePassword = ConvertTo-SecureString -String $StringPassword -AsPlainText -Force
$DomainName = "jctest.com"
$NetbiosName = "jctest"
$DomainUserFirstName = "JumpCloud"
$DomainUserLastName = "User1"
$DomainUserDisplayName = $DomainUserFirstName + " " + $DomainUserLastName
$DomainUserUserName = "jcuser1"
$DomainUserEmail = $DomainUserUserName + "@" + $DomainName

Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest `
-confirm:$false `
-CreateDnsDelegation:$false `
-DatabasePath "C:\\ADDS\\NTDS" `
-DomainMode "WinThreshold" `
-DomainName $DomainName `
-DomainNetbiosName $NetbiosName `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\\ADDS\\Logs" `
-SysvolPath "C:\\ADDS\\SYSVOL" `
-SkipAutoConfigureDns:$false `
-SkipPreChecks:$false `
-SafeModeAdministratorPassword $SecureAdminSafeModePassword `
-NoRebootOnCompletion:$false `
-Force:$true

New-ADOrganizationalUnit -Name "JumpCloud" -Path "DC=$netbiosName,DC=COM"
New-ADOrganizationalUnit -Name "Users" -Path "OU=JumpCloud,DC=$netbiosName,DC=COM"

New-ADUser -Name $DomainUserDisplayName -GivenName $DomainUserFirstName -Surname $DomainUserLastName -SamAccountName $DomainUserUserName -EmailAddress $DomainUserEmail -UserPrincipalName $DomainUserEmail -Path "OU=Users,OU=JumpCloud,DC=$NetbiosName,DC=com" -AccountPassword $SecureAdminSafeModePassword -Enabled $true -PasswordNeverExpires $true 
