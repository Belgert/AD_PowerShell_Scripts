## - Exports all Local AD user accounts with the below attributes to a CSV 
## - Name, LastLogonDate, Enabled, ManagerName, OU 

## - Selecting a folder to save to  
Write-Host "Please select a folder to save to." -ForegroundColor red  
Add-Type -AssemblyName System.Windows.Forms  
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog  
[void]$folderBrowser.ShowDialog()  
$save = $folderBrowser.SelectedPath  

## - Obtaining and exporting data 
Get-aduser -Filter { Name -like "*" } -properties * | 
Select Name, LastLogonDate, Enabled, @{n = "ManagerName"; e = { (Get-ADUser -Identity $_.Manager -properties DisplayName).DisplayName } }, @{n = 'OU'; e = { ($_.distinguishedName -Split ",")[1].Replace("OU=", "").Replace("CN=", "") } } | 
Export-CSV -Path "$save\AD_AllUserAccounts $((Get-Date -format MM-dd-yyyy).ToString()).csv" -NoTypeInformation 

## - RR 