function Export-CAPolicies {
    param(
        [Parameter(Mandatory = $true)]
        $path,
        [array]$ConditionalAccessPolicyIds
    )

    #Confirm Path is valid
    if (!(Test-Path $path)) {
        Write-Error "Path is not valid, exiting"
        exit
    }

    #If Policy IDs is specified, export the specific policies otherwise get and export all policies
    if ($ConditionalAccessPolicyIds) {
        Write-Host "Exporting Specified Policies - Supplied: $($ConditionalAccessPolicyIds.length)" -ForegroundColor Green
        foreach ($Id in $ConditionalAccessPolicyIds) {
            $Policy = Get-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $Id
            ExportCAPolicy -policy $Policy -path $path
        }
    }
    else {
        Write-Host "----- Fetching All Policies -----" -ForegroundColor Green
        $Polcies = Get-MgIdentityConditionalAccessPolicy
        Write-Host "Found $($polcies.length) policies - Exporting policies to $path" -ForegroundColor Green
        foreach ($Policy in $Polcies) {
            ExportCAPolicy -policy $Policy -path $path
        }
    }
}

#This function helps the import function by recreating some of the controls/sessions that need to be cleaned in order to be able to create the policy
function SanatisePolicy {
    param(
        $policy
    )
    #Remove ID, Created time and Modified Time
    $policy.Id = $null;
    $policy.createdDateTime = $null;
    $policy.modifiedDateTime = $null;

    #Clean Authentication Strength, only needs to contain the ID
    if($policy.grantControls.authenticationStrength.Id){
        $policy.grantControls.AuthenticationStrength = @{
            "Id" = $policy.grantControls.authenticationStrength.Id
        }
    }
    #Override the State and Set to Report Only
    $policy.State = "enabledForReportingButNotEnforced"
    return $policy
}

function ExportCAPolicy {
    param(
        $policy,
        $path
    )
    $destination = $path + $policy.Id + ".json"
    $policy = SanatisePolicy -policy $policy
    $policy.ToJsonString() | Out-File $destination
    Write-Host " - Exported $($Policy.DisplayName) -> $destination"
}


Export-CAPolicies -path "/Users/joshb/Documents/Projects/EntraCAEasyClone/Policies/" 