function Import-CAPolicies{
    param(
        [Parameter(Mandatory = $true)]
        $path,
        [array]$Policies,
        $ignoreChecks = $false
    )

    #Confirm Path is valid
    if (!(Test-Path $path)) {
        Write-Error "Path is not valid, exiting"
        exit
    }

    #Get Current Policies for Checks
    if(!$ignoreChecks){
        Write-Host "Getting List of Current Policies - To skip this step apply the flag -ignoreChecks:`$true" -ForegroundColor Yellow
        $currentPolicies = Get-MgIdentityConditionalAccessPolicy
    }

    #If specific Policies is set Import only the supplied Policies, otherwise import all
    $JsonFiles = Get-ChildItem -Path $path -Filter "*.json"
    if($Policies){
        Write-Host "Importing Specified Policies - Supplied: $($Policies.length)" -ForegroundColor Green
        Write-Host "Scanning Path for Matching JSON files"
        foreach($jfile in $JsonFiles){
            if($Policies -contains $jfile.Name){
                Write-Host "- Located Policy: $($jfile.Name) (Importing)"
                $json = Get-Content $jfile
                if(performChecksAndContinue -json $json -currentPolicies $currentPolicies){
                    Add-CAPolicy -Json $json
                }
            }
        }
    }else{
        Write-Host "Importing All Policies - Found $($JsonFiles.Length) json files - Attempting to Import" -ForegroundColor Green
        foreach($jfile in $JsonFiles){
            Write-Host "- Located Policy: $($jfile.Name) (Importing)" -ForegroundColor Green
            $json = Get-Content $jfile
            if(performChecksAndContinue -json $json -currentPolicies $currentPolicies){
                Add-CAPolicy -Json $json
            }
        }
    }
}

#Function Checks if a policy exits with the same displayname, if it does will prompt the user if they would like to create
#Default Return type is true. Will only return false if a duplicate is found and the user selects to not create
function performChecksAndContinue{
    param(
        $json,
        $currentPolicies
    )
    #Get Display Name
    $pattern = '"displayName": "(.*?)",'
    $displayName = ($json | Select-String -Pattern $pattern).Matches.Groups[1].Value
    foreach($policy in $currentPolicies){
        if($policy.DisplayName -like $displayName){
            Write-Host "Policy Allready Exists with the name: $displayName. Would you like to create anyway [y/N]" -ForegroundColor Yellow
            if (!($response = Read-Host "Responce [N]")) { $response = "N" }
            if($response -like "Y" -or $response -like "Yes") {return $true}
            return $false
        }
    }
    return $true
}

#Go Line by line and sanatise the json, Most is handled in the Export function but odata and ID are always exported and need to get cleared
function SanatiseJson{
    param(
        [Parameter(Mandatory)]
        $json
    )
    $sanatisedJson = @()
    foreach($line in $json){
       if($line -like "*@odata.context*"){continue}
       if($line -like "  `"id*"){continue}
       $sanatisedJson += $line
    }
    return $sanatisedJson
}

function Add-CAPolicy{
    param(
        $Json
    )
    $Json = SanatiseJson -json $Json
    Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" -Body $Json
}

Export-ModuleMember Import-CAPolicies