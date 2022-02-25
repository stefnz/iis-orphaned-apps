#Requires -RunAsAdministrator

import-module WebAdministration

# Remove web applications
Remove-WebApplication -Site 'Default Web Site' -Name 'TestApps/app1' -ErrorAction SilentlyContinue
Remove-WebApplication -Site 'Default Web Site' -Name 'TestApps/app2' -ErrorAction SilentlyContinue
Remove-WebApplication -Site 'Default Web Site' -Name 'TestApps' -ErrorAction SilentlyContinue

Remove-WebApplication -Site 'Default Web Site' -Name 'Orphans-WebApp/orphan1' -ErrorAction SilentlyContinue
Remove-WebApplication -Site 'Default Web Site' -Name 'Orphans-WebApp/orphan2' -ErrorAction SilentlyContinue
Remove-WebApplication -Site 'Default Web Site' -Name 'Orphans-WebApp' -ErrorAction SilentlyContinue

Remove-WebApplication -Site 'Default Web Site' -Name 'Orphans-vdir/orphan1' -ErrorAction SilentlyContinue
Remove-WebApplication -Site 'Default Web Site' -Name 'Orphans-vdir/orphan2' -ErrorAction SilentlyContinue

Remove-Item -PSPath 'IIS:\Sites\Default Web Site\Orphans-vdir' -Recurse -Force -ErrorAction SilentlyContinue

# Remove folders from the file system
$testPathBase = 'C:\OrphanedAppsTest\'

Remove-Item -Path $testPathBase -Recurse -Force -ErrorAction SilentlyContinue
