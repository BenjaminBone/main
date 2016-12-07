##==========================================================================================================##
##Script Name = User Account Management - Frontpoint Security												
##Author Name = Ben Bone																				
##Author Mail = ben.bone@frontpointsecurity.com																
##Version	  = v1.0 (11/8/2016)																			
##Description = 														
##==========================================================================================================##
#=====================================================#
# Global Variables - ADDED
#=====================================================#
$Date = Get-Date -format g
$MyName = [Environment]::UserName
$ErrorActionPreference = "SilentlyContinue"
#=====================================================#


#============================================================================#
# Function FP-NewADUser -- Create New User Account
# Set new PW to - Welcome1!
# Create new user from Template
#============================================================================#



#=====================================================#
# Function -- Main Menu (Non-Preferred Name)
#=====================================================#






#============================================================================#
# Menu / Body 
#============================================================================#

do
{
	cls
	write-host -fore Red `n "==============================================================================================="
		write-host -fore Cyan `n "                                -- Manage User Tool --"
		write-host -fore Yellow `n "MSOL Connected User                      = " -NoNewline
        write-host "[" -ForegroundColor Yellow -NoNewline
        write-host "$FullName" -ForegroundColor White -NoNewline
        write-host "]" -ForegroundColor Yellow -NoNewline
		write-host -fore Yellow `n "Today's Date                             = " -NoNewline
        write-host "[" -ForegroundColor Yellow -NoNewline
        write-host "$Date" -ForegroundColor White -NoNewline
        write-host "]" -ForegroundColor Yellow -NoNewline
	write-host -fore Red `n "==============================================================================================="
		write-host -fore Cyan `n "                                -- Employee Details --"
		write-host -fore Yellow `n "Employee Email                           = " -NoNewline
        write-host "[" -ForegroundColor Yellow -NoNewline
        write-host "$emailaddress" -ForegroundColor White -NoNewline
        write-host "]" -ForegroundColor Yellow -NoNewline
		write-host -fore Yellow `n "Employee ID                              = " -NoNewline
        write-host "[" -ForegroundColor Yellow -NoNewline
        write-host "$employeeID" -ForegroundColor White -NoNewline
        write-host "]" -ForegroundColor Yellow -NoNewline
	write-host -fore Red `n "==============================================================================================="
	write-host -fore Cyan `n "                                -- Set User Details --"
	write-host -fore Red `n "==============================================================================================="
	write-host -fore Green `t '[1] Connect to MSOL'
	write-host -fore Green `t '[2] Enter Username'
	write-host -fore Green `t '[3] Set Employee ID for User'
	write-host -fore White `t "[E] Exit Utility"
	write-host -fore Red `n "==============================================================================================="
	$result = read-host
	cls
	switch ($result)
	{
		1 {
        $UserCredential = Get-Credential
        $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
        Import-PSSession $Session
        $FullName = $UserCredential | select-object -ExpandProperty UserName
		}        
		2 {
        $emailaddress = read-host -prompt "Please enter email address of employee"
        $User = Get-ADUser -LDAPFilter "(userPrincipalName=$emailaddress)"
        If ($User -eq $Null) {"User does not already exist, Please enter a valid email address!"}
        Else {"User found in AD!"} 
        $employeeID = Get-ADUser -LDAPFilter "(userPrincipalName=$emailaddress)" -Properties * | Select-Object -ExpandProperty employeeID
        If ($employeeID -eq $Null) {"User does not have an Emplyee ID"}
        Else {"User currently has an Employee ID"}
		}  
		3 {
        $setID = read-host -prompt "Please enter employee ID"
        Get-ADUser -LDAPFilter "(userPrincipalName=$emailaddress)" | set-aduser -EmployeeID $setID
        $employeeID = Get-ADUser -LDAPFilter "(userPrincipalName=$emailaddress)" -Properties * | Select-Object -ExpandProperty employeeID
		}      
}

	IF (!($result -eq "E"))
	{
		Pause
	}
}
while (!($result -eq "E"))

#=================================#
#End Of Script
#=================================#