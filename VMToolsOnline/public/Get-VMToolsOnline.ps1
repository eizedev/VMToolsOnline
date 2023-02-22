#requires -version 3
Function Get-VMToolsOnline {

    <#
      .SYNOPSIS
        Uses Powershell webcmdlets to connect to vmware.com and get a list of all
        VMware Tools versions along with supporting information.

      .DESCRIPTION
        Uses Powershell webcmdlets to connect to vmware.com and get a list of all
        VMware Tools versions along with supporting information.  Also includes
        a derived property for RSS showing if a given Tools version is affected.

        All version information is obtained live from the internet, while the RSS
        bug is checked against a specific list of affected versions included in the script.

        The RSS issue was introduced in VMware Tools 9536 (9.10.0) and resolved in VMware Tools
        10282 (10.1.10). We treat versions greater than 10282 as being resolved and therefore
        return false for the RssImpactedTools property.


      .NOTES
        Script:         Get-VMToolsOnline.ps1
        Author:         Mike Nisk
        Contributor(s): René (github@eize.dev)

      .EXAMPLE
      Get-VMToolsOnline

      This example runs the script with no parameters.  By default you will get a
      report of all available VMware Tools versions on your screen. WE maintain the
      original formatting where possible.  To use the data as objects see the PassThru
      parameter in the next example.

      .EXAMPLE
      $versions = Get-VMToolsOnline -PassThru

      This example saves the report to a variable.  We use the PassThru parameter which returns
      all data as objects. If we did not use PassThru, then the output is formatted using Format-Table
      which is not object friendly.

      .Example
      Get-VMToolsOnline -ShowHeader

      This example returns the default comments available on the official tools site.
      It contains helpful information about versioning, releases, etc.

      .Example
      Get-VMToolsOnline -Raw

      Returns the original content with native formatting.  This is the same thing you would see
      if you navigated to https://packages.vmware.com/tools/versions using a browser.

  #>

    [CmdletBinding(DefaultParameterSetName = 'DefaultSet')]
    [OutputType('PSCustomObject', 'System.Object[]')]
    Param(
        #String. The URI of the official VMware Tools release page. No need to change this.
        [Parameter(ParameterSetName = 'DefaultSet')]
        [string]$Uri = 'https://packages.vmware.com/tools/versions',
        <#
        Switch. Optionally, show header comments from the official VMware patch release page.
        The comments are valid only for the first four columns, which are provided by VMware.
        Additional columns added by the community (i.e. 'RSSAffectedTools') will not be documented
        in the header.
        #>
        [Parameter(ParameterSetName = 'ShowHeaderSet')]
        [Alias('IncludeHeader')]
        [switch]$ShowHeader,
        #Switch. Optionally, return the raw format of the web uri returned.
        [Parameter(ParameterSetName = 'RawSet')]
        [switch]$Raw,
        #Switch. Optionally, return object info with no formatting.
        [Parameter(ParameterSetName = 'DefaultSet')]
        [switch]$PassThru,
        #URI. Optionally, add a proxy in URL format 'http://proxy.domain.de:8080' to use proxy for WebRequest
        [Parameter(ParameterSetName = 'DefaultSet')]
        [System.Uri]$Proxy
    )

    Process {

        $PatchListUri = $Uri
        if ([string]::IsNullOrEmpty($Proxy)) {
            $PatchListObj = Invoke-WebRequest -Uri $PatchListUri -UseBasicParsing
        }
        else {
            $PatchListObj = Invoke-WebRequest -Uri $PatchListUri -UseBasicParsing -Proxy $Proxy
        }
        If ($PatchListObj) {
            Write-Verbose -Message ('Using VMware Tools version list mapping from URI {0}' -f $PatchListUri)
        }
        Else {
            Throw ('Problem getting information from URI {0}' -f $PatchListUri)
        }

        #slice and dice
        $lineFeed = ($PatchListObj.Content -split "`n")
        $HeaderComments = $lineFeed -match '^#'
        $mainContent = $lineFeed | Where-Object { $_ -notmatch '^#' }

        #Replace whitespace with just one space
        $mainContent = ($mainContent -replace '\s+', ' ')

        #region RSS affected tools
        <#
        This is a derived list of all versions of VMware tools affected by the well known RSS issue.
        The problem manifests as degraded performance of vmxnet3 based Windows guest operating systems
        that have bursty workloads.  All network traffic is serviced on CPU core 0, instead of being
        spread across gos processors.

        VMware does not publish an official list of affected versions, though it can be extrapolated
        based on VMware's communications.  It would be nice to have a list like this available right
        next to the uri that lists tools versions, but it does not exist.  As such, we use this derived
        list.

        Tip:  Remember that RSS is not turned on inside the gos by default.  The recommendation is to
        enable this for multi-processor virtual machines that fit the gos and workload type that will
        benefit from this.  Using the script herein, one can find a proper version of tools to update to.

        Warning: You may need a two step upgrade of tools to get to the desired version.  Also, you may not
        be able to upgrade your Tools for protected VMs until you have upgraded SRM.  This must be reviewed.

    #>
        $RSS_Affected_Tools = @(
            '10279',
            '10277',
            '10272',
            '10272',
            '10252',
            '10249',
            '10249',
            '10249',
            '10249',
            '10249',
            '10249',
            '10249',
            '10249',
            '10248',
            '10246',
            '10245',
            '10240',
            '10240',
            '10240',
            '10240',
            '10240',
            '9541',
            '9541',
            '9537',
            '9536'
        )
        #endregion

        $Script:result = @()
        foreach ($line in $mainContent) {

            # Create variables to hold line info
            [int32]$StrToolsVersion = ($line -split ' ')[0]
            [string]$StrEsxVersion = ($line -split ' ')[1]


            #Handle versions not yet bundled with ESX
            #Skip empty ESXi BuildNumber while validating each line
            If ($StrEsxVersion -match 'esx/0.0') {
                [string]$StrEsxBuildNumber = 'NotBundled'
                [System.Version]$VerToolsRelease = ($line -split ' ')[2]
                [System.Nullable[int64]]$IntToolsBuildNumber = ($line -split ' ')[3]
            }
            elseif ($StrEsxVersion -match 'esx/4' -or $StrEsxVersion -match 'esx/3') {
                [int32]$StrEsxBuildNumber = 0
                [System.Version]$VerToolsRelease = ($line -split ' ')[2]
                [int64]$IntToolsBuildNumber = 0
            }
            Else {
                [string]$StrEsxBuildNumber = ($line -split ' ')[2]
                [System.Version]$VerToolsRelease = ($line -split ' ')[3]
                [System.Nullable[int64]]$IntToolsBuildNumber = ($line -split ' ')[4]
            }

            #Handle RSS info
            If ($RSS_Affected_Tools -contains $StrToolsVersion) {
                [bool]$RssAffectedTools = $true
            }
            Else {
                [bool]$RssAffectedTools = $false
            }

            #Future Tools
            <#
            Handle RSS stance on future tools. The RSS Issue was resolved in
            version 10282. Treat future versions as not affected by returning
            false for the RssAffectedTools property.
            #>
            [int]$RssResolvedVersion = '10282'
            [int]$NumToolsVersion = $StrToolsVersion
            If ($NumToolsVersion -gt $RssResolvedVersion ) {
                [bool]$RssAffectedTools = $false
            }

            #Finally, create report object for this line entry
            $LineObj = [PSCustomObject]@{
                ToolsVersion     = [int32]$StrToolsVersion
                EsxVersion       = [string]$StrEsxVersion
                EsxBuild         = [string]$StrEsxBuildNumber
                ToolsRelease     = [System.Version]$VerToolsRelease
                ToolsBuild       = [int64]$IntToolsBuildNumber
                RssAffectedTools = [bool]$RssAffectedTools
            }

            #Validate one of the properties as a quick test, and then add to result object.
            If ($LineObj.ToolsVersion) {
                $Script:result += $LineObj
            }
            Else {
                Continue
            }
        } #End Foreach
    } #End Process

    End {

        #Handle PassThru switch. Returns objects. This is available in the DefaultSet parameter set.
        If ($PSCmdlet.MyInvocation.BoundParameters['PassThru']) {
            return $result
        }
        #Handle Raw switch. Writes the raw output on screen. This is available in the RawSet parameter set.
        Elseif ($PSCmdlet.MyInvocation.BoundParameters['Raw']) {
            Write-Output -InputObject ''
            return $lineFeed
        }
        #Handle ShowHeader. Writes the official VMware comments on screen before showing data. This is available in the ShowHeaderSet parameter set.
        Elseif ($PSCmdlet.MyInvocation.BoundParameters['ShowHeader']) {
            Write-Output -InputObject ''
            Write-Output -InputObject $HeaderComments
            Write-Output -InputObject ''
            return $result | Format-Table -AutoSize
        }
        Else {
            #Handle default output. Returns text to screen. This is available in the DefaultSet parameter set
            $result | Select-Object -Property ToolsVersion, EsxVersion, EsxBuild, ToolsRelease, ToolsBuild, RssAffectedTools | Format-Table -AutoSize
        }
    } #End End
} #End Function