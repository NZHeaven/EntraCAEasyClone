# EntraCAEasyClone
Small Powershell Module to Export and Import CA Policies between tenants

Requires Microsoft Graph PowerShell SDK (v1.0)
Install Instructions: https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0

---

You first must auth with the below command, this will authenticate you with the MS Graph with the required scopes
- Connect-MgGraph -Scopes "Application.Read.All", "Policy.Read.All", "Policy.ReadWrite.ConditionalAccess"