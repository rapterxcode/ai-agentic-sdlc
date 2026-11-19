# Critical Windows Event IDs for Forensics

## Security Log (Security.evtx)
### Authentication
- **4624** - Successful Logon
  - Type 2: Interactive (console)
  - Type 3: Network (SMB, RDP)
  - Type 10: RemoteInteractive (RDP)
- **4625** - Failed Logon (brute-force indicator)
- **4648** - Logon using explicit credentials (runas, Pass-the-Hash)
- **4672** - Special privileges assigned (admin rights)
- **4776** - Domain controller authentication (NTLM)

### Account Management
- **4720** - User account created
- **4722** - User account enabled
- **4724** - Password reset attempt
- **4732** - User added to security-enabled local group
- **4738** - User account changed

### Kerberos Attacks
- **4768** - Kerberos TGT requested (AS-REQ)
- **4769** - Kerberos service ticket requested (TGS-REQ) - Kerberoasting
- **4771** - Kerberos pre-authentication failed

### Process Creation
- **4688** - Process created (requires audit policy enabled)
  - Check CommandLine for suspicious commands
  - ParentProcessName for unusual chains

### Object Access
- **4663** - File/object accessed
- **4656** - Handle to object requested

## System Log (System.evtx)
- **7034** - Service crashed unexpectedly
- **7035** - Service control manager: service stopped/started
- **7040** - Service startup type changed (disabled → automatic)
- **7045** - New service installed

## Application Log (Application.evtx)
- **1000** - Application error (crash dumps)
- **1001** - Windows Error Reporting

## PowerShell Logs
### PowerShell Operational (Microsoft-Windows-PowerShell/Operational)
- **4103** - Module logging (commands executed)
- **4104** - Script block logging (full script content)

### PowerShell Classic (Windows PowerShell.evtx)
- **400** - Engine state changed (PowerShell started)
- **403** - Engine state changed (PowerShell stopped)
- **600** - Provider lifecycle (WSMan provider = remoting)

## Task Scheduler (Microsoft-Windows-TaskScheduler/Operational)
- **106** - Task registered
- **140** - Task updated
- **141** - Task deleted
- **200** - Task executed
- **201** - Task completed

## RDP/Terminal Services
### TerminalServices-LocalSessionManager/Operational
- **21** - Remote Desktop session logon succeeded
- **22** - Remote Desktop shell started
- **23** - Remote Desktop session logoff
- **24** - Remote Desktop session disconnected
- **25** - Remote Desktop session reconnected

### TerminalServices-RemoteConnectionManager/Operational
- **1149** - User authentication succeeded

## Windows Defender
### Microsoft-Windows-Windows Defender/Operational
- **1116** - Malware detected
- **1117** - Malware action taken
- **5001** - Real-time protection disabled
- **5007** - Configuration changed

## WMI Activity (Microsoft-Windows-WMI-Activity/Operational)
- **5857** - WMI activity detected (persistence technique)
- **5860** - Registration of temporary event consumer
- **5861** - Registration of permanent event consumer

## Firewall
### Microsoft-Windows-Windows Firewall With Advanced Security/Firewall
- **2004** - Firewall rule added
- **2005** - Firewall rule modified
- **2006** - Firewall rule deleted

## Sysmon (if deployed)
- **1** - Process creation
- **3** - Network connection
- **7** - Image/DLL loaded
- **8** - CreateRemoteThread (injection)
- **10** - Process access (credential dumping)
- **11** - File created
- **13** - Registry value set
- **22** - DNS query

## Quick Analysis Commands
```powershell
# Failed logons from external IPs
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625} | 
  Where-Object {$_.Properties[19].Value -notmatch '^192\.168\.'} | 
  Select-Object TimeCreated, @{N='IP';E={$_.Properties[19].Value}}

# Successful logons Type 10 (RDP)
Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4624} | 
  Where-Object {$_.Properties[8].Value -eq 10} | 
  Select-Object TimeCreated, @{N='User';E={$_.Properties[5].Value}}, @{N='IP';E={$_.Properties[18].Value}}

# New services created
Get-WinEvent -FilterHashtable @{LogName='System'; ID=7045} | 
  Select-Object TimeCreated, @{N='ServiceName';E={$_.Properties[0].Value}}, @{N='ImagePath';E={$_.Properties[1].Value}}

# PowerShell script blocks
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PowerShell/Operational'; ID=4104} | 
  Select-Object TimeCreated, @{N='ScriptBlock';E={$_.Properties[2].Value}}
```
