# EntraCAEasyClone
Small Powershell Module to Export and Import Conditional Access Policies from Microsoft Entra.

---
### Installation
- Donload the latest release or clone the repo.
- Open powershell and navigate to the root folder. Run the below command to import the module into scope
```
Import-Module .\EntraCAEasyClone.psd1
```
**NOTE:** You first must auth with the below command, this will authenticate you with the MS Graph with the required scopes
```
Connect-MgGraph -Scopes "Application.Read.All", "Policy.Read.All", "Policy.ReadWrite.ConditionalAccess"
```
---
### Module Member: Export-CAPolicies
#### Description
The Export-CAPolicies PowerShell module function exports Conditional Access Policies from Microsoft 365 to JSON files. It will sanatise the Json ready to be imported by Import-CAPolicies

#### Prerequisites
Before using the Export-CAPolicies function, ensure you have the following:

- A valid Microsoft 365 tenant with the necessary permissions to manage Conditional Access Policies.
- PowerShell with the required modules and permissions (MG-Graph)

#### Cmdlet Usage
```
Export-CAPolicies -path <string> [-ConditionalAccessPolicyIds <array>]
```

#### Parameters
##### -path (Mandatory)
Specifies the path where the JSON policy files will be saved. The function will use this directory to store the exported policies as separate JSON files.

##### -ConditionalAccessPolicyIds (Optional)
An array of specific Conditional Access Policy IDs that you want to export. If specified, only the policies with the matching IDs will be exported. If not specified, all policies will be fetched and exported.

#### Examples
Export all policies to the "C:\ExportedPolicies" directory:
```
Export-CAPolicies -path "C:\ExportedPolicies\"
```
Export specific policies with IDs "PolicyId1" and "PolicyId2" to the "C:\ExportedPolicies" directory:
```
Export-CAPolicies -path "C:\ExportedPolicies\" -ConditionalAccessPolicyIds @("PolicyId1", "PolicyId2")
```

#### Note
- The function uses the Microsoft Graph API to fetch the policies, so ensure you have the necessary permissions and valid authentication to perform these operations.
- The exported JSON files can be used as input for the Import-CAPolicies function to import the policies back into your Microsoft 365 environment.
- Be cautious while exporting and importing policies, as they may have significant implications on the security and access controls of your Microsoft 365 environment. Always review the policies before importing or exporting.
- For more information about Microsoft 365 Conditional Access Policies, refer to the official documentation and Microsoft Graph API reference.
---

### Module Member: Import-CAPolicies
#### Description
This function allows you to import policies from JSON files and by default will perform checks to avoid duplicate policys getting created.

Cmdlet Usage
```
Import-CAPolicies -path <string> [-Policies <array>] [-ignoreChecks <bool>]
```

#### Parameters
##### -path (Mandatory)
Specifies the path where the JSON policy files are located. The function will search for files with the .json extension in this directory.

##### -Policies (Optional)
An array of file names that you want to import. If specified, only the policies with matching names will be imported. If not specified, all policies found in the provided path will be imported.

##### -ignoreChecks (Optional)
By default, the function performs checks to avoid importing policies with duplicate names. Set this flag to $true if you want to skip the checks and import policies without any validation.

#### Examples
Import all policies from the "C:\Policies" directory, performing checks for duplicate policy names:
```
Import-CAPolicies -path "C:\Policies\"
```
Import only specific policies (Policy1 and Policy2) from the "C:\Policies" directory, skipping checks:
```
Import-CAPolicies -path "C:\Policies" -Policies @("Policy1.json", "Policy2.json") -ignoreChecks $true
```

#### Note
- By Design the Module will override the state and set it to Report. This is to stop accidental lock outs.
- The function uses the Microsoft Graph API to add the policies, so ensure you have the necessary permissions and valid authentication to perform these operations.
- Be cautious while importing policies, as they may have significant implications on the security and access controls of your Microsoft 365 environment. Always review the policies before importing.
- For more information about Microsoft 365 Conditional Access Policies, refer to the official documentation and Microsoft Graph API reference.
