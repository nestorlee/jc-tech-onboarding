$StringPassword = "P@ssw0rd123"
$SecureAdminSafeModePassword = ConvertTo-SecureString -String $StringPassword -AsPlainText -Force
$DomainName = "jctest.com"
$NetbiosName = "jctest"
$DomainUserFirstName = "JumpCloud"
$DomainUserLastName = "User1"
$DomainUserDisplayName = $DomainUserFirstName + " " + $DomainUserLastName
$DomainUserUserName = "jcuser1"
$DomainUserEmail = $DomainUserUserName + "@" + $DomainName

New-ADOrganizationalUnit -Name "JumpCloud" -Path "DC=$netbiosName,DC=COM"
New-ADOrganizationalUnit -Name "Users" -Path "OU=JumpCloud,DC=$netbiosName,DC=COM"

New-ADUser -Name $DomainUserDisplayName -GivenName $DomainUserFirstName -Surname $DomainUserLastName -SamAccountName $DomainUserUserName -EmailAddress $DomainUserEmail -UserPrincipalName $DomainUserEmail -Path "OU=Users,OU=JumpCloud,DC=$NetbiosName,DC=com" -AccountPassword $SecureAdminSafeModePassword -Enabled $true -PasswordNeverExpires $true 
