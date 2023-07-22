function Export-MFARules {
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

    #If Policy IDs is specified, export the specific policies otherwise get and export all polcieic
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
function ExportCAPolicy {
    param(
        $policy,
        $path
    )
    $destination = $path + $policy.Id + ".json"
    ConvertTo-Json $policy -Depth 100 | Out-File $destination
    Write-Host " - Exported $($Policy.DisplayName) -> $destination"
}


Export-MFARules -path "/Users/joshb/Documents/Projects/MFA_Clone_Module/Policies/" -ConditionalAccessPolicyIds "aa018f6a-881a-4cfa-bb1a-70b986170521","de23c439-668e-4be2-a156-9513900b0939"