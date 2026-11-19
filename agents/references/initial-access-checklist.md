# Initial Access Checklist

## Linux Systems
### SSH Access
- [ ] `/var/log/auth.log` - Brute-force patterns (multiple failures → success)
- [ ] `/etc/ssh/sshd_config` - PermitRootLogin yes, PasswordAuthentication yes
- [ ] `~/.ssh/authorized_keys` - Unauthorized public keys

### Web Server Exploits
- [ ] Apache: version vs CVE database, malicious `.htaccess`, loaded modules
- [ ] Nginx: `nginx.conf` reverse proxy misconfig, error logs with stack traces
- [ ] Tomcat: Manager app access, deployed WAR files in `webapps/`

### Kernel & Service Exploits
- [ ] `uname -r` vs DirtyPipe (CVE-2022-0847), DirtyCOW, eBPF exploits
- [ ] `dpkg -l` / `rpm -qa` - Outdated services (polkit, sudo, systemd)

## Windows Systems
### RDP Attacks
- [ ] Event ID 4624 (successful logon) from external IPs
- [ ] Event ID 4625 (failed logon) - Brute-force patterns
- [ ] Event ID 4648 (explicit credentials) - Pass-the-hash

### SMB & Exploits
- [ ] EternalBlue (MS17-010), BlueKeep (CVE-2019-0708)
- [ ] PrintNightmare (CVE-2021-34527), Zerologon (CVE-2020-1472)
- [ ] `Get-HotFix` - Missing security patches

### IIS & SQL Server
- [ ] Web shell uploads: `*.aspx`, `*.ashx` in `C:\inetpub\wwwroot\`
- [ ] SQL Server: `xp_cmdshell` enabled, weak `sa` password

## CI/CD Tools
### Jenkins
- [ ] `config.xml` - `<useSecurity>false</useSecurity>`
- [ ] Plugins vulnerable: Script Security, Matrix Authorization
- [ ] CVE-2024-23897 (CLI file read), CVE-2023-27898 (RCE)
- [ ] Access logs: `/cli`, `/script`, `/scriptText` endpoints

### GitLab
- [ ] CVE-2023-7028 (account takeover via password reset)
- [ ] `gitlab.rb` - External URL exposed, default tokens
- [ ] Runner registration tokens in `/var/log/gitlab/`

### Others
- [ ] Bamboo, TeamCity, CircleCI: Configuration exports, API tokens

## Docker & Kubernetes
### Docker
- [ ] Exposed daemon: `tcp://0.0.0.0:2375` or `docker.sock` mounted
- [ ] `docker ps -a` - Privileged containers
- [ ] `docker history <image>` - Suspicious layers

### Kubernetes
- [ ] API Server: `--anonymous-auth=true`, no RBAC
- [ ] Dashboard exposed without auth
- [ ] Audit logs: `/var/log/kubernetes/audit/audit.log`
- [ ] `kubectl auth can-i --list --as=system:anonymous`
- [ ] CVE-2018-1002105, CVE-2023-5528

## API Gateway & Serverless
### AWS
- [ ] API Gateway: IAM authorizer misconfig, CORS `*`
- [ ] Lambda: Over-permissive IAM role, env vars with secrets
- [ ] CloudWatch Logs: 4xx/5xx spikes, unusual paths

### GraphQL / REST
- [ ] GraphQL introspection enabled, query depth attacks
- [ ] BOLA/IDOR: manipulated IDs in API calls
- [ ] API keys in URLs/logs

## Web Application Vulnerabilities (OWASP Top 10)
### Injection
- [ ] SQL Injection: `' OR '1'='1`, `UNION SELECT`, error-based
- [ ] Command Injection: `;whoami`, `| curl attacker.com`
- [ ] LDAP, XML, NoSQL injection patterns

### Access Control
- [ ] Path Traversal: `../../etc/passwd`, `..\..\windows\win.ini`
- [ ] IDOR: Sequential IDs, UUID guessing

### Cryptographic Failures
- [ ] Exposed: `.git/`, `.env`, `web.config`, `application.properties`
- [ ] Secrets in JS bundles: `grep -r "AKIA" frontend/dist/`

### Vulnerable Components
- [ ] Log4Shell (CVE-2021-44228), Spring4Shell (CVE-2022-22965)
- [ ] `package.json`, `pom.xml`, `requirements.txt` vs NVD database

### SSRF
- [ ] Metadata service: `169.254.169.254` in access logs
- [ ] Internal port scanning via user input

## Container Images & Registry
- [ ] Unofficial base images (not `docker.io/library/`)
- [ ] Cryptominers in image layers: `dive` tool analysis
- [ ] Registry: Image replacement (same tag, different digest)
- [ ] `~/.docker/config.json` - Stolen credentials
