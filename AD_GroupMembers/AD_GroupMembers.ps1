## - Pulls all Local AD groups and its members with the following attributes: 
## - Member, Group, GroupType, Source 

## - Selecting a folder to save to  
Write-Host "Please select a folder to save to." -ForegroundColor red  
Add-Type -AssemblyName System.Windows.Forms  
$folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog  
[void]$folderBrowser.ShowDialog()  
$save = $folderBrowser.SelectedPath 

## - Variables 
$ADgroups = Get-ADGroup -Filter * -properties * 
$data = @() 

## - Get all groups and members 
ForEach ($AD in $ADgroups) { 

    If ([string]::IsNullOrEmpty($AD.Members)) { 
        $data += [pscustomobject] @{ 
            Member    = "No Members" 
            Group     = $AD.Name 
            GroupType = $AD.GroupCategory 
            Source    = "Local AD"
        }
    } 
    Else { 
        $members = $AD.Members 
        ForEach ($member in $members) { 
            $member = $member.substring(0, $member.IndexOf(',')) 
            $member = $member -replace "CN=" 
            $data += [pscustomobject] @{ 
                Member    = $member 
                Group     = $AD.Name 
                GroupType = $AD.GroupCategory 
                Source    = "Local AD"
            }
        }
    }
} 

## - Export Report 
$data | Export-CSV -Path "$save\AD_GroupMember $((Get-Date -format MM-dd-yyyy).ToString()).csv" -NoTypeInformation  

## - RR
