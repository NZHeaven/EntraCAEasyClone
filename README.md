# EntraCAEasyClone
Small Powershell Module to Export and Import CA Policies

Requires Microsoft Graph PowerShell SDK (v1.0)
Install Instructions: https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0

---

You first must auth with the below command, this will authenticate you with the MS Graph with the required scopes
- Connect-MgGraph -Scopes "Application.Read.All", "Policy.Read.All", "Policy.ReadWrite.ConditionalAccess"

---
### Import-CAPolicies
#### Description
The Import-CAPolicies PowerShell module function is designed to simplify the process of importing Conditional Access Policies into Microsoft 365. This function allows you to import policies from JSON files and perform checks to avoid duplicate policy names. It uses Microsoft Graph API to add the policies to the target environment.

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
