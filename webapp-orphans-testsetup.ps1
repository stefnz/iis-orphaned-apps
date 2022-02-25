#Requires -RunAsAdministrator

function New-Directory {
    Param(
        [Parameter(Mandatory=$true)]
        [string] $path
    )

    if(Test-Path $path){
        return
    }

    [void] (New-Item -Path $path -ItemType Directory) # suppress output to host
}

#
# Create the required folders on the file system
#

$testPathBase = 'C:\OrphanedAppsTest\'

New-Directory (Join-Path $testPathBase 'orphans-webapp\orphan1')
New-Directory (Join-Path $testPathBase 'orphans-webapp\orphan2')

New-Directory (Join-Path $testPathBase 'orphans-vdir\orphan1')
New-Directory (Join-Path $testPathBase 'orphans-vdir\orphan2')

New-Directory (Join-Path $testPathBase 'apps\app1')
New-Directory (Join-Path $testPathBase 'apps\app2')

import-module WebAdministration
#
# Create the virtual directory
#
New-WebVirtualDirectory -Site 'Default Web Site' -Name 'Orphans-vdir' -PhysicalPath (Join-Path $testPathBase 'orphans-vdir')

#
# Create the web applications
#
New-WebApplication -Site 'Default Web Site' -Name 'TestApps' -PhysicalPath (Join-Path $testPathBase 'apps') 
ConvertTo-WebApplication -PSPath 'IIS:\Sites\Default Web Site\TestApps\app1'
ConvertTo-WebApplication -PSPath 'IIS:\Sites\Default Web Site\TestApps\app2'

New-WebApplication -Site 'Default Web Site' -Name 'Orphans-WebApp' -PhysicalPath (Join-Path $testPathBase 'orphans-webapp')
ConvertTo-WebApplication -PSPath 'IIS:\Sites\Default Web Site\Orphans-webapp\Orphan1'
ConvertTo-WebApplication -PSPath 'IIS:\Sites\Default Web Site\Orphans-webapp\Orphan2'
 
ConvertTo-WebApplication -PSPath 'IIS:\Sites\Default Web Site\Orphans-vdir\orphan1'
ConvertTo-WebApplication -PSPath 'IIS:\Sites\Default Web Site\Orphans-vdir\orphan2'