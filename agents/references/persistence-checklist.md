# Persistence Mechanisms Checklist

## Linux Persistence
### Scheduled Tasks
- [ ] `/var/spool/cron/crontabs/*` - User cron jobs
- [ ] `/etc/crontab`, `/etc/cron.d/`, `/etc/cron.hourly/` - System cron
- [ ] `systemctl list-timers` - Systemd timers

### Services
- [ ] `/etc/systemd/system/*.service` - Custom services
- [ ] `/usr/lib/systemd/system/*.service` - Modified system services
- [ ] `/etc/init.d/*` - Legacy init scripts
- [ ] `systemctl list-unit-files --state=enabled` - Auto-start services

### SSH Backdoors
- [ ] `/root/.ssh/authorized_keys` - Unauthorized keys
- [ ] `/home/*/.ssh/authorized_keys` - All users
- [ ] `/etc/ssh/sshd_config` - PermitRootLogin force-command bypass

### Rootkits & LD_PRELOAD
- [ ] `/etc/ld.so.preload` - Preloaded malicious libraries
- [ ] `lsmod` - Suspicious kernel modules (`.ko` files)
- [ ] Modified system binaries: `rpm -Va` or `debsums -c`

### User Accounts
- [ ] `/etc/passwd` - UID 0 accounts (besides root)
- [ ] `/etc/shadow` - Weak hashes, recent changes
- [ ] Hidden users: `cut -d: -f1 /etc/passwd | grep -v '^#'`

### Profile Scripts
- [ ] `~/.bashrc`, `~/.bash_profile`, `~/.profile` - Malicious commands
- [ ] `/etc/profile`, `/etc/bash.bashrc` - System-wide

## Windows Persistence
### Registry Run Keys
- [ ] `HKLM\Software\Microsoft\Windows\CurrentVersion\Run`
- [ ] `HKCU\Software\Microsoft\Windows\CurrentVersion\Run`
- [ ] `HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce`
- [ ] `HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run`

### Scheduled Tasks
- [ ] `C:\Windows\System32\Tasks\` - XML files
- [ ] `schtasks /query /fo LIST /v` - Hidden tasks
- [ ] Task Scheduler logs: `Microsoft-Windows-TaskScheduler/Operational`

### Services
- [ ] `sc query` - Suspicious services
- [ ] `Get-Service | Where-Object {$_.Status -eq "Running"}` (PowerShell)
- [ ] Service DLLs: `HKLM\SYSTEM\CurrentControlSet\Services\*\Parameters`

### WMI Event Subscriptions
- [ ] `Get-WmiObject -Class __FilterToConsumerBinding -Namespace root\subscription`
- [ ] `Get-WmiObject -Class __EventFilter -Namespace root\subscription`
- [ ] `Get-WmiObject -Class __EventConsumer -Namespace root\subscription`

### Startup Folders
- [ ] `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\`
- [ ] `C:\Users\*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\`

## Application-Level Persistence
### Jenkins
- [ ] `init.groovy` - Auto-execute on startup
- [ ] `init.groovy.d/*.groovy` - Multiple init scripts
- [ ] Scheduled jobs: Check `jobs/*/config.xml` for `<triggers>` with cron
- [ ] Modified plugins: Compare hashes with official Jenkins Update Center
- [ ] Backdoor users: `users/*/config.xml`

### GitLab
- [ ] Webhooks: Project Settings → Integrations
- [ ] Modified CI/CD pipelines: `.gitlab-ci.yml` in repos
- [ ] Runner registration tokens: `/etc/gitlab-runner/config.toml`
- [ ] System hooks: Admin Area → System Hooks

### Databases
- [ ] MySQL: Event Scheduler jobs (`SHOW EVENTS`)
- [ ] PostgreSQL: Triggers on sensitive tables
- [ ] MongoDB: Server-side JavaScript
- [ ] SQL Server: SQL Agent jobs, CLR assemblies

## Container & Orchestration Persistence
### Docker
- [ ] Modified base images: `docker images --digests`
- [ ] Container auto-restart: `docker inspect --format='{{.HostConfig.RestartPolicy}}' <container>`
- [ ] Malicious volumes: `docker volume ls` + inspect mounts

### Kubernetes
- [ ] CronJobs: `kubectl get cronjobs -A`
- [ ] DaemonSets: `kubectl get daemonsets -A` - Runs on all nodes
- [ ] Admission Controllers: Custom webhooks that auto-modify pods
- [ ] Malicious service accounts: `kubectl get sa -A` + check RBAC bindings
- [ ] Persistent volumes: `kubectl get pv` - Data survives pod deletion

### Container Registry
- [ ] ECR/GCR/ACR: New images pushed to official repos
- [ ] Image tags overwritten with malicious digests

## Cloud Infrastructure Persistence
### AWS
- [ ] New IAM users: `aws iam list-users`
- [ ] Access keys: `aws iam list-access-keys --user-name <user>`
- [ ] Roles with trust relationships: `aws iam list-roles`
- [ ] Lambda functions: `aws lambda list-functions`
- [ ] Lambda layers: Malicious code injected via layers
- [ ] EventBridge rules: Auto-execute Lambda on schedule/events
- [ ] S3 bucket notifications: Trigger Lambda on file upload

### Azure
- [ ] New users/service principals: `az ad user list`, `az ad sp list`
- [ ] Role assignments: `az role assignment list`
- [ ] Function Apps: `az functionapp list`
- [ ] Logic Apps: Workflow automation

### GCP
- [ ] Service accounts: `gcloud iam service-accounts list`
- [ ] Cloud Functions: `gcloud functions list`
- [ ] Cloud Scheduler jobs: `gcloud scheduler jobs list`
- [ ] Compute Engine startup scripts: Check instance metadata

## Detection Tips
### Time-based Analysis
- Check file modification times (mtime): `find / -type f -mtime -7` (modified last 7 days)
- Compare with known-good baseline: `rpm -Va`, `debsums`, AIDE

### Process Persistence
- Look for unusual parent-child relationships: `pstree`, `ps auxf`
- Hidden processes: Compare `ps` vs `/proc` directories

### Network Persistence
- Reverse shells that reconnect: Check cron + network connections
- DNS tunneling for C2: Analyze DNS query logs
