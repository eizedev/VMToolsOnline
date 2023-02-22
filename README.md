# VMToolsOnline

This module uses Powershell to connect to packages.vmware.com and get a list of all VMware Tools versions.  
Also shows which versions were impacted by the RSS issue with VMware Tools.

## Getting Started

Clone this repository or download the files in this repository (the module) to the desired local directory and then import similar to:

```powershell
Import-Module $pwd/VMToolsOnline
```

## Included Function

This module contains one function, `Get-VMToolsOnline`.
The module structure is a convenience for those that prefer modules.
If you want just the function, it is located in the `public` folder of the module.

## Changelog

version 0.1.0   - Initial release
<br>

version 1.0.0.1 - Added handling for `Invoke-WebRequest` to `UseBasicParsing` by default when performing the lookup of versions available on vmware.com
<br>

version 1.1.0.0 - Added support for latest version on `https://packages.vmware.com/tools/versions`. Also added Tools build number for ESXi 5 and later versions
<br>

## help output

```powershell
NAME
    Get-VMToolsOnline

SYNOPSIS
    Uses Powershell webcmdlets to connect to vmware.com and get a list of all
    VMware Tools versions along with supporting information.


SYNTAX
    Get-VMToolsOnline [-Uri <String>] [-PassThru] [<CommonParameters>]

    Get-VMToolsOnline [-ShowHeader] [<CommonParameters>]

    Get-VMToolsOnline [-Raw] [<CommonParameters>]


DESCRIPTION
    Uses Powershell webcmdlets to connect to vmware.com and get a list of all
    VMware Tools versions along with supporting information.  Also includes
    a derived property for RSS showing if a given Tools version is affected.

    All version information is obtained live from the internet, while the RSS
    bug is checked against a specific list of affected versions included in the script.

    The RSS issue was introduced in VMware Tools 9536 (9.10.0) and resolved in VMware Tools
    10282 (10.1.10). We treat versions greater than 10282 as being resolved and therefore
    return false for the RssImpactedTools property.


PARAMETERS
    -Uri <String>
        String. The URI of the offical VMware Tools release page. No need to change this.

        Required?                    false
        Position?                    named
        Default value                https://packages.vmware.com/tools/versions
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -ShowHeader [<SwitchParameter>]
        Switch. Optionally, show header comments from the official VMware patch release page.
        The comments are valid only for the first four columns, which are provided by VMware.
        Additional columns added by the community (i.e. 'RSSAffectedTools') will not be documented
        in the header.

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Raw [<SwitchParameter>]
        Switch. Optionally, return the raw format of the web uri returned.

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -PassThru [<SwitchParameter>]
        Switch. Optionally, return object info with no formatting.

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).


NOTES


        Script:     Get-VMToolsOnline.ps1
        Author:     Mike Nisk

    -------------------------- EXAMPLE 1 --------------------------

    PS C:\>Get-VMToolsOnline

    This example runs the script with no parameters.  By default you will get a
    report of all available VMware Tools versions on your screen. We maintain the
    original formatting where possible.  To use the data as objects see the PassThru
    parameter in the next example.




    -------------------------- EXAMPLE 2 --------------------------

    PS C:\>$versions = Get-VMToolsOnline -PassThru

    This example saves the report to a variable.  We use the PassThru parameter which returns
    all data as objects. If we did not use PassThru, then the output is formatted using Format-Table
    which is not object friendly.




    -------------------------- EXAMPLE 3 --------------------------

    PS C:\>Get-VMToolsOnline -ShowHeader

    This example returns the default comments available on the official tools site.
    It contains helpful information about versioning, releases, etc.

    -------------------------- EXAMPLE 4 --------------------------

    PS C:\>Get-VMToolsOnline -Raw

    Returns the original content with native formatting.  This is the same thing you would see
    if you navigated to https://packages.vmware.com/tools/versions using a browser.

```

## Example Output

```powershell
PS C:\> Get-VMToolsOnline

ToolsVersion EsxVersion  EsxBuild   ToolsRelease ToolsBuild RssAffectedTools
------------ ----------  --------   ------------ ---------- ----------------
       12325 esx/8.0p01  21203435   12.1.5         20735119            False
       12320 esx/7.0p06  20842708   12.1.0         20219665            False
       12325 esx/0.0     NotBundled 12.1.5         20735119            False
       12294 esx/8.0     20513097   12.0.6         20104755            False
       12294 esx/6.7p08  20497097   12.0.6         20104755            False
       12294 esx/6.5p09  20502893   12.0.6         20104755            False
       12320 esx/0.0     NotBundled 12.1.0         20219665            False
       10361 esx/0.0     NotBundled 10.3.25        20206839            False
       12294 esx/0.0     NotBundled 12.0.6         20104755            False
       12288 esx/7.0p05  20036589   12.0.0         19345655            False
       12288 esx/6.7p07  19898906   12.0.0         19345655            False
       12293 esx/0.0     NotBundled 12.0.5         19716617            False
       12288 esx/6.5p08  19588618   12.0.0         19345655            False
       11365 esx/7.0p04  19482537   11.3.5         18557794            False
       11365 esx/6.7p06  18828794   11.3.5         18557794            False
       10360 esx/0.0     NotBundled 10.3.24        18733423            False
       11360 esx/6.5p07  18678235   11.3.0         18090558            False
       11360 esx/7.0u3   18644231   11.3.0         18090558            False
       11334 esx/7.0p03  18426014   11.2.6         17901274            False
       11333 esx/7.0u2   17630552   11.2.5         17337674            False
       11333 esx/6.7p05  17700523   11.2.5         17337674            False
       11329 esx/6.5p06  17477841   11.2.1         17243207            False
       10359 esx/6.5p06  17477841   10.3.23        17030940            False
       11328 esx/0.0     NotBundled 11.2.0         16938113            False
       11301 esx/7.0p02  17325551   11.1.5         16724464            False
       11297 esx/7.0u1   16850804   11.1.1         16303738            False
       11297 esx/6.7p04  17167734   11.1.1         16303738            False
       11297 esx/6.7p03  16713306   11.1.1         16303738            False
       11297 esx/6.5p05  16576891   11.1.1         16303738            False
       11296 esx/7.0p01  16324942   11.1.0         16036546            False
       10358 esx/0.0     NotBundled 10.3.22        15902021            False
       11270 esx/0.0     NotBundled 11.0.6         15940789            False
       11269 esx/6.7p02  16075168   11.0.5         15389592            False
       11269 esx/7.0     15843807   11.0.5         15389592            False
       11265 esx/6.5p04  15256549   11.0.1         14773994            False
       10357 esx/6.7p01  15160138   10.3.21        14772444            False
       11265 esx/6.7p01  15160138   11.0.1         14773994            False
       11264 esx/0.0     NotBundled 11.0.0         14549434            False
       10356 esx/0.0     NotBundled 10.3.20        14389227            False
       10346 esx/6.0p08  14513180   10.3.10        12406962            False
       10346 esx/6.7u3   14320388   10.3.10        12406962            False
       10346 esx/6.5u3   13932383   10.3.10        12406962            False
       10341 esx/6.7u2   13006603   10.3.5         10430147            False
       10341 esx/6.5p03  10884925   10.3.5         10430147            False
       10338 esx/6.7ep05 10764712   10.3.2          9925305            False
       10338 esx/6.7u1   10302608   10.3.2          9925305            False
       10309 esx/6.0ep19 10719132   10.2.5          8068406            False
       10309 esx/6.0p07  9239799    10.2.5          8068406            False
       10305 esx/6.5ep11 10719125   10.2.1          8267844            False
       10305 esx/6.7ep2a 9214924    10.2.1          8267844            False
       10305 esx/6.5u2   8294253    10.2.1          8267844            False
       10304 esx/6.7     8169922    10.2.0          7253323            False
       10287 esx/6.5p02  7388607    10.1.15         6677369            False
       10282 esx/6.0p06  6921384    10.1.10         6082533            False
       10279 esx/6.5u1   5969303    10.1.7          5541682             True
       10277 esx/6.0p05  5572656    10.1.5          5055683             True
       10272 esx/6.5p01  5146846    10.1.0          4449150             True
       10272 esx/6.5     4564106    10.1.0          4449150             True
       10252 esx/6.5     4564106    10.0.12         4448496             True
       10249 esx/5.5p11  6480324    10.0.9                0             True
       10249 esx/5.5ep11 5230635    10.0.9                0             True
       10249 esx/6.0u3   5050593    10.0.9                0             True
       10249 esx/5.5p10  4722766    10.0.9                0             True
       10249 esx/6.0p04  4600944    10.0.9                0             True
       10249 esx/5.5p09  4345813    10.0.9                0             True
       10249 esx/6.0p03  4192238    10.0.9                0             True
       10249 esx/5.5p08  4179633    10.0.9                0             True
       10248 esx/0.0     NotBundled 10.0.8                0             True
       10246 esx/6.0u2   3620759    10.0.6                0             True
       10245 esx/0.0     NotBundled 10.0.5                0             True
       10240 esx/6.0ep05 3566359    10.0.0                0             True
       10240 esx/6.0p02  3380124    10.0.0                0             True
       10240 esx/5.5p07  3248547    10.0.0                0             True
       10240 esx/5.5ep10 3568722    10.0.0                0             True
       10240 esx/5.5ep09 3343343    10.0.0                0             True
        9541 esx/6.0ep04 3247720    9.10.5                0             True
        9541 esx/6.0u1   3029758    9.10.5                0             True
        9537 esx/6.0p01  2809209    9.10.1                0             True
        9536 esx/6.0     2494585    9.10.0                0             True
        9359 esx/5.5ep08 3116895    9.4.15                0            False
        9359 esx/5.5u3   3029944    9.4.15                0            False
        9356 esx/5.5p05  2668677    9.4.12                0            False
        9355 esx/5.5ep07 2638301    9.4.11                0            False
        9355 esx/5.5ep06 2456374    9.4.11                0            False
        9355 esx/5.5p04  2403361    9.4.11                0            False
        9354 esx/5.5ep05 2143827    9.4.10                0            False
        9354 esx/5.5p03  2143827    9.4.10                0            False
        9354 esx/5.5u2   2068190    9.4.10                0            False
        9350 esx/5.5p02  1892794    9.4.6                 0            False
        9349 esx/5.5ep04 1881737    9.4.5                 0            False
        9349 esx/5.5ep03 1746974    9.4.5                 0            False
        9349 esx/5.5ep02 1750340    9.4.5                 0            False
        9349 esx/5.5u1   1623387    9.4.5                 0            False
        9344 esx/5.5p01  1474528    9.4.0                 0            False
        9344 esx/5.5     1331820    9.4.0                 0            False
        9233 esx/5.1p09  3872664    9.0.17                0            False
        9232 esx/5.1p08  3070626    9.0.16                0            False
        9231 esx/5.1p07  2583090    9.0.15                0            False
        9231 esx/5.1u3   2323236    9.0.15                0            False
        9229 esx/5.1p06  2126665    9.0.13                0            False
        9228 esx/5.1p05  1897911    9.0.12                0            False
        9227 esx/5.1ep05 1900470    9.0.11                0            False
        9227 esx/5.1p04  1743533    9.0.11                0            False
        9226 esx/5.1ep04 1612806    9.0.10                0            False
        9226 esx/5.1u2   1483097    9.0.10                0            False
        9221 esx/5.1p03  1312873    9.0.5                 0            False
        9221 esx/5.1p02  1157734    9.0.5                 0            False
        9221 esx/5.1ep03 1117900    9.0.5                 0            False
        9221 esx/5.1u1   1065491    9.0.5                 0            False
        9217 esx/5.1ep02 1021289    9.0.1                 0            False
        9217 esx/5.1p01  914609     9.0.1                 0            False
        9216 esx/5.1     799733     9.0.0                 0            False
        8401 esx/5.0p13  3982828    8.6.17                0            False
        8400 esx/5.0p12  3086167    8.6.16                0            False
        8399 esx/5.0p11  2509828    8.6.15                0            False
        8398 esx/5.0p10  2312428    8.6.14                0            False
        8398 esx/5.0p09  1976090    8.6.14                0            False
        8397 esx/5.0ep06 1918656    8.6.13                0            False
        8397 esx/5.0p08  1851670    8.6.13                0            False
        8396 esx/5.0p07  1489271    8.6.12                0            False
        8395 esx/5.0u3   1311175    8.6.11                0            False
        8395 esx/5.0p06  1254542    8.6.11                0            False
        8395 esx/5.0ep05 1117897    8.6.11                0            False
        8395 esx/5.0p05  1024429    8.6.11                0            False
        8394 esx/5.0u2   914586     8.6.10                0            False
        8397 esx/5.0p08  1739451    8.6.13                0            False
        8389 esx/5.0p04  821926     8.6.5                 0            False
        8389 esx/5.0p03  768111     8.6.5                 0            False
        8389 esx/5.0u1   623860     8.6.5                 0            False
        8384 esx/5.0p02  515841     8.6.0                 0            False
        8384 esx/5.0p01  474610     8.6.0                 0            False
        8384 esx/5.0     469512     8.6.0                 0            False
        8307 esx/4.1p11  0          8.3.19                0            False
        8307 esx/4.1p10  0          8.3.19                0            False
        8307 esx/4.1p09  0          8.3.19                0            False
        8307 esx/4.1p08  0          8.3.19                0            False
        8306 esx/4.1p07  0          8.3.18                0            False
        8305 esx/4.1p06  0          8.3.17                0            False
        8305 esx/4.1u3   0          8.3.17                0            False
        8300 esx/4.1p05  0          8.3.12                0            False
        8300 esx/4.1p04  0          8.3.12                0            False
        8300 esx/4.1u2   0          8.3.12                0            False
        8295 esx/4.1p03  0          8.3.7                 0            False
        8295 esx/4.1u1   0          8.3.7                 0            False
        8290 esx/4.1     0          8.3.2                 0            False
        8199 esx/4.0p15  0          8.0.7                 0            False
        8199 esx/4.0p14  0          8.0.7                 0            False
        8198 esx/4.0p13  0          8.0.6                 0            False
        8197 esx/4.0ep09 0          8.0.5                 0            False
        8196 esx/4.0p12  0          8.0.4                 0            False
        8196 esx/4.0p11  0          8.0.4                 0            False
        8196 esx/4.0u4   0          8.0.4                 0            False
        8196 esx/4.0p10  0          8.0.4                 0            False
        8196 esx/4.0u3   0          8.0.4                 0            False
        8195 esx/4.0u2   0          8.0.3                 0            False
        8194 esx/4.0u1   0          8.0.2                 0            False
        8192 esx/4.0     0          8.0.0                 0            False
        7304 esx/3.5p27  0          7.4.8                 0            False
        7304 esx/3.5p25  0          7.4.8                 0            False
        7304 esx/3.5p24  0          7.4.8                 0            False
        7304 esx/3.5u5   0          7.4.8                 0            False
        7303 esx/3.5u4   0          7.4.7                 0            False
        7302 esx/3.5u3   0          7.4.6                 0            False
        7302 esx/3.5u2   0          7.4.6                 0            False
```

## Show the header

Show the header by using `-Raw` or `-IncludeHeader`

```powershell
PS C:\> Get-VMToolsOnline -IncludeHeader | more

# VMware version-mapping file.
#
# This file provides a one-to-one mapping between VMware Tools for
# ESX/ESXi version-number codes, and paths to OSP repositories suitable
# for that Tools version.
#
# The ESXi server mapping is only to show that the particular version of
# Tools ships with that particular ESXi server build number, but the Tools
# can work with a greater range of ESXi versions.
#
# Column 1: Tools version on NGC/VI Client
# Column 2: ESXi server version.'esx/0.0' indicates that the tools version
# is not yet bundled with ESXi.
# Column 3: ESXi server build number
# Column 4: Tools version on guest Setup/About page
# Column 5: Tools build number
#
# VMTools versions EOGS


ToolsVersion EsxVersion  EsxBuild   ToolsRelease ToolsBuild RssAffectedTools
------------ ----------  --------   ------------ ---------- ----------------
       12325 esx/8.0p01  21203435   12.1.5         20735119            False
       12320 esx/7.0p06  20842708   12.1.0         20219665            False
       12325 esx/0.0     NotBundled 12.1.5         20735119            False
       12294 esx/8.0     20513097   12.0.6         20104755            False
       12294 esx/6.7p08  20497097   12.0.6         20104755            False
       12294 esx/6.5p09  20502893   12.0.6         20104755            False
       12320 esx/0.0     NotBundled 12.1.0         20219665            False
       10361 esx/0.0     NotBundled 10.3.25        20206839            False
       12294 esx/0.0     NotBundled 12.0.6         20104755            False
       12288 esx/7.0p05  20036589   12.0.0         19345655            False
       12288 esx/6.7p07  19898906   12.0.0         19345655            False
       12293 esx/0.0     NotBundled 12.0.5         19716617            False
       12288 esx/6.5p08  19588618   12.0.0         19345655            False
       11365 esx/7.0p04  19482537   11.3.5         18557794            False
       11365 esx/6.7p06  18828794   11.3.5         18557794            False
       10360 esx/0.0     NotBundled 10.3.24        18733423            False
       11360 esx/6.5p07  18678235   11.3.0         18090558            False
       11360 esx/7.0u3   18644231   11.3.0         18090558            False
       11334 esx/7.0p03  18426014   11.2.6         17901274            False
       11333 esx/7.0u2   17630552   11.2.5         17337674            False
       11333 esx/6.7p05  17700523   11.2.5         17337674            False
       11329 esx/6.5p06  17477841   11.2.1         17243207            False
       10359 esx/6.5p06  17477841   10.3.23        17030940            False
       11328 esx/0.0     NotBundled 11.2.0         16938113            False
       11301 esx/7.0p02  17325551   11.1.5         16724464            False
       11297 esx/7.0u1   16850804   11.1.1         16303738            False
       11297 esx/6.7p04  17167734   11.1.1         16303738            False
       11297 esx/6.7p03  16713306   11.1.1         16303738            False
       11297 esx/6.5p05  16576891   11.1.1         16303738            False
       11296 esx/7.0p01  16324942   11.1.0         16036546            False
       10358 esx/0.0     NotBundled 10.3.22        15902021            False
       11270 esx/0.0     NotBundled 11.0.6         15940789            False
       11269 esx/6.7p02  16075168   11.0.5         15389592            False
       11269 esx/7.0     15843807   11.0.5         15389592            False
       11265 esx/6.5p04  15256549   11.0.1         14773994            False
       10357 esx/6.7p01  15160138   10.3.21        14772444            False
```
