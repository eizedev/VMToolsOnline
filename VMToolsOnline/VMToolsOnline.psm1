<#	
    ===========================================================================
    Author:       	Mike Nisk
    Contributor(s): René (github@eize.dev)
    Filename:     	VMToolsOnline.psm1
    Version:        1.1.0.0
    Generated on:   14Oct2018
    Updated on:     22Feb2022
    -------------------------------------------------------------------------
    Module Name:    VMToolsOnline
    ===========================================================================


#>

# Get public and private function files
$Public = @( Get-ChildItem -Path $PSScriptRoot\public\*-*.ps1 -Recurse -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\private\*-*.ps1 -Recurse -ErrorAction SilentlyContinue )

# Dot source the files
foreach ($FunctionFile in @($Public + $Private)) {

    try {

        . $FunctionFile.fullname

    }
    catch {
        Write-Error -Message $Error[0].exception.Message
        #Write-Error -Message "Failed to import function $($FunctionFile.fullname): $_"
    }
}

# Export the Public modules
Export-ModuleMember -Function $Public.Basename
