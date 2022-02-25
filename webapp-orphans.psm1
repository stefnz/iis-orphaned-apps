<#
.SYNOPSYS
Is the current script executing with elevated permissions? 

.NOTES
In PowerShell 4 or higher, can use #requires -version
#>
function Test-IsExecutionElevated {
    $windowsIdentity=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $windowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($windowsIdentity)
    $administratorRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

    return [boolean]$windowsPrincipal.IsInRole($administratorRole)
}

<#
.SYNOPSYS
Find any web applications registered in IIS that don't map to a valid file location or do not have a valid parent location.
#>
function Find-Orphans {
    param(
        [Parameter(Mandatory=$false)]
        [string] $Site = 'Default Web Site'       
    )

    #test to see if script is running elevated
    if(-not (Test-IsExecutionElevated)){
        Write-Output 'The script must be run with elevated priliveges, please re-run as Admin.' 
        return
    }

    import-module WebAdministration

    Write-Output 'Finding orphaned web applications in IIS...'

    foreach($webApp in Get-WebApplication -Site $Site ){
        
        #
        # does the physical path exist for the web application?
        #
        if(-not (Test-Path $webApp.PhysicalPath)){
            #Write-Output "$($webApp.path), the physical path no longer exists."
            Write-Output $webApp
        }
    
        #
        # does the parent path exist for the web application?
        #
        $parentPath = Split-Path $webApp.path
    
        if(-not (Test-Path (Join-Path "IIS:\Sites\$Site" $parentPath))){
            #Write-Output "$($webApp.path) is an orphaned web application."
            Write-Output $webApp
        }
    }

    Write-Output 'Done.'      
}


function Remove-Orphans {
    param(
        [Parameter(Mandatory=$false)]
        [string] $Site = 'Default Web Site'       
    )

    #test to see if script is running elevated
    if(-not (Test-IsExecutionElevated)){
        Write-Output 'The script must be run with elevated priliveges, please re-run as Admin.' 
        return
    }

    import-module WebAdministration

    Write-Output 'Removing orphaned web applications in IIS...'

    foreach($webApp in Get-WebApplication -Site $Site ){
        
        #
        #does the physical path exist for the web application?
        #
        if(-not (Test-Path $webApp.PhysicalPath)){
            Write-Output "Removing $($webApp.path), the physical path no longer exists."
            Remove-WebApplication -Name $webApp.path -Site $Site -WhatIf
        }
    
        #
        # does the parent path exist for the web application?
        #
        $parentPath = Split-Path $webApp.path
    
        if(-not (Test-Path (Join-Path "IIS:\Sites\$Site" $parentPath))){
            Write-Output "Removing $($webApp.path) as it is an orphaned web application."
        
            Remove-WebApplication -Name $webApp.path -Site $Site -WhatIf
        }
    }

    Write-Output 'Done.'    
}






