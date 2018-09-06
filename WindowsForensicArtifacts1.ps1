#Author: Quintin Kovach
$computer = Read-Host "Input Computer to Analyze"
Enter-PSSession -ComputerName $computer

Write-Host "Date, Timezone, and Uptime"
Get-Date
[TimeZoneInfo]::Local
Get-WmiObject Win32_OperatingSystem | Select-Object LastBootUpTime

Write-Host "OS Version"
(Get-WmiObject Win32_OperatingSystem).Caption
(Get-WmiObject Win32_OperatingSystem).Version

Write-Host
Write-Host "System Hardware"
Get-WmiObject win32_processor
$ram = (Get-WmiObject -Class win32_computersystem).TotalPhysicalMemory/1Gb
Write-Output $ram" GB of RAM"
Get-WmiObject win32_logicaldisk

Write-Host
Write-Host "Domain Controller"
#$domaincontroller = [System.Directoryservices.Activedirectory.Domain]::GetCurrentDomain()
#$domainIP = 

Write-Host
Write-Host "Hostname and Domain"
Write-Output "Hostname: $env:COMPUTERNAME"
$currDomain = $env:computername.$env:userdnsdomain
Get-CimInstance Win32_ComputerSystem | Select-Object Domain

Write-Host
Write-Host "Users"
Get-LocalUser | Select-Object Name,SID,LastLogon

Write-Host
Write-Host "Boot Services"
Get-CimInstance Win32_StartupCommand | Select-Object Name,User,Location

Write-Host
Write-Host "Scheduled Tasks"
Get-ScheduledTask
Get-ScheduledJob

Write-Host
Write-Host "Network Info"
Write-Host "ARP Table"
arp -a
Write-Host "Routing Table"
route print
Write-Host "MAC Addresses"
getmac
Write-Host "IP Addresses"
Get-NetIPAddress | ft IPAddress, InterfaceAlias
Write-Host "DHCP Server"
Get-WmiObject Win32_NetworkAdapterConfiguration | select DHCPServer
Write-Host "DNS Servers"
Get-DnsClientServerAddress
Write-Host "Gateway Addresses"
Get-NetIPConfiguration | % IPv4defaultgateway | fl nexthop
Write-Host "Listening Services"
Get-NetTCPConnection -State Listen | ft State, localport, ElementName, LocalAddress, RemoteAddress
Write-Host "Current Connections"
Get-NetTCPConnection | ft creationtime, LocalPort, LocalAddress, remoteaddress, owningprocess, state
Write-Host "DNS Cache"
Get-DnsClientCache

Write-Host
Write-Host "Network Shares"
Get-SmbShare | ft Name, Description, Path, ShareType

Write-Host
Write-Host "Printers"
Get-Printer | ft Name, Comment, JobCount, PrinterStatus, Priority

Write-Host
Write-Host "WiFi Profiles"
netsh wlan show profiles

Write-Host
Write-Host "Installed Software"
Get-WmiObject -Class Win32_Product

Write-Host
Write-Host "Processes"
Get-WmiObject Win32_Process | Select-Object ProcessName, ProcessID, ParentProcessID, Path

Write-Host
Write-Host "Drivers"
Get-WindowsDriver -Online -All | Select-Object Driver, BootCritical, OriginalFileName, Version, Date, ProviderName

Write-Host
Write-Host "User Documents and Downloads"
foreach ($directory in Get-ChildItem -Path 'C:\Users') {
    if(Test-Path "C:\Users\$directory\Documents") {
        ls C:\Users\$directory\Documents
        }
    if(Test-Path "C:\Users\$directory\Downloads") {
        ls C:\Users\$directory\Downloads
    }
    }

Write-Host
Write-Host "PATH"
cd env:
ls path | ft Value

Write-Host
Write-Host "Audio Devices"
Get-CimInstance Win32_Sounddevice

Write-Host
Write-Host "BIOS Information"
Get-CimInstance Win32_SystemBIOS