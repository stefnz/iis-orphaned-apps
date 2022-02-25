# Orphaned Web Apps in IIS

The configuration in IIS is hierarchical. A web application can inherit settings from the parent and so each ancestor config is reviewed when determining the value. If there is a break in the chain, for example a parent virtual directory or web application is removed then strange and cryptic errors in IIS may result.

This is uncommon if automation is used to repeatably build the necessary hosting infrastructure, however it can be an issue on a local development environment especially if experimenting.

Finding orphaned web applications can be challenging as they cannot be seen in IIS Manager. To see then, you need to use the WebAdministration PowerShell module or examine the applicationhost.config in C:\Windows\System32\inetsrv\config\

The PowerShell script webapp-orphans.ps1 contains commands that can find and remove orphaned web applications.

Find-Orphans
Prints out the IIS path of any web applications where either:
1. the phyiscal path of the web application is invalid
2. the parent web application or virtual direction of the web application is missing

Remove-Orphans
Finds orphans as above and removes them.