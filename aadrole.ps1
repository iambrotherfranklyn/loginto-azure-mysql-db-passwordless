# Script to assign permissions to the UMI "umiservertest"

import-module AzureAD
$tenantId = 'YOUR TENANT ID' # Your Azure AD tenant ID

Connect-AzureAD -TenantID $tenantId
# Log in as a user with a "Global Administrator" or "Privileged Role Administrator" role
# Script to assign permissions to an existing UMI 
# The following Microsoft Graph permissions are required: 
#   User.Read.All
#   GroupMember.Read.All
#   Application.Read.ALL

# Search for Microsoft Graph
$AAD_SP = Get-AzureADServicePrincipal -SearchString "Microsoft Graph";
$AAD_SP
# Use Microsoft Graph; in this example, this is the first element $AAD_SP[0]

#Output

#ObjectId                             AppId                                DisplayName
#--------                             -----                                -----------
#47d73278-e43c-4cc2-a606-c500b66883ef 00000003-0000-0000-c000-000000000000 Microsoft Graph
#44e2d3f6-97c3-4bc7-9ccd-e26746638b6d 0bf30f3b-4a52-48df-9a82-234910c4a086 Microsoft Graph #Change 

$MSIName = "secure-user-assinged-identity";  # Name of your user-assigned
$MSI = Get-AzureADServicePrincipal -SearchString $MSIName 
if($MSI.Count -gt 1)
{ 
Write-Output "More than 1 principal found, please find your principal and copy the right object ID. Now use the syntax $MSI = Get-AzureADServicePrincipal -ObjectId OBJECT ID OF MANAGED-IDENTITY"

# Choose the right UMI

Exit
} 

# If you have more UMIs with similar names, you have to use the proper $MSI[ ]array number

# Assign the app roles

$AAD_AppRole = $AAD_SP.AppRoles | Where-Object {$_.Value -eq "User.Read.All"}
New-AzureADServiceAppRoleAssignment -ObjectId $MSI.ObjectId  -PrincipalId $MSI.ObjectId  -ResourceId $AAD_SP.ObjectId[0]  -Id $AAD_AppRole.Id 
$AAD_AppRole = $AAD_SP.AppRoles | Where-Object {$_.Value -eq "GroupMember.Read.All"}
New-AzureADServiceAppRoleAssignment -ObjectId $MSI.ObjectId  -PrincipalId $MSI.ObjectId  -ResourceId $AAD_SP.ObjectId[0]  -Id $AAD_AppRole.Id
$AAD_AppRole = $AAD_SP.AppRoles | Where-Object {$_.Value -eq "Application.Read.All"}
New-AzureADServiceAppRoleAssignment -ObjectId $MSI.ObjectId  -PrincipalId $MSI.ObjectId  -ResourceId $AAD_SP.ObjectId[0]  -Id $AAD_AppRole.Id