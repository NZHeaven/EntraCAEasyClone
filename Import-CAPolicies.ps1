function Import-CAPolicies{
    param(
        [Parameter(Mandatory = $true)]
        $path,
        [array]$Policies
    )

    #Confirm Path is valid
    if (!(Test-Path $path)) {
        Write-Error "Path is not valid, exiting"
        exit
    }

    #If specific Policies is set Import only the supplied Policies, otherwise import all
    $JsonFiles = Get-ChildItem -Path $path -Filter "*.json"
    if($Policies){
        Write-Host "Importing Specified Policies - Supplied: $($Policies.length)" -ForegroundColor Green
        Write-Host "Scanning Path for Matching JSON files"
        foreach($jfile in $JsonFiles){
            if($Policies -contains $jfile.Name){
                Write-Host "- Located Policy: $($jfile.Name) (Importing)"
                $json = Get-Content $jfile | SanatiseJson
                Add-CAPolicy -Json $json
            }
        }
    }else{
        Write-Host "Importing All Policies - Found $($JsonFiles.Length) json files - Attempting to Import" -ForegroundColor Green
        foreach($jfile in $JsonFiles){
            Write-Host "- Located Policy: $($jfile.Name) (Importing)" -ForegroundColor Green
            $json = Get-Content $jfile
            $json = SanatiseJson -json $json
            Add-CAPolicy -Json $json
        }
    }
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
    Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies" -Body $Json
}

#Import-CAPolicies -Policies "aa018f6a-881a-4cfa-bb1a-70b986170521.json" -path "/Users/joshb/Documents/Projects/EntraCAEasyClone/Policies/"
Import-CAPolicies -path "/Users/joshb/Documents/Projects/EntraCAEasyClone/Policies/" 