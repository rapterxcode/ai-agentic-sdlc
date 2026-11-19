# Cloud Forensics Evidence Guide

## AWS
### CloudTrail (Audit Logs)
**Location:** S3 bucket configured in CloudTrail settings
**Key Events to Check:**
```json
{
  "eventName": "AssumeRole",  // Role assumption (privilege escalation)
  "eventName": "GetSessionToken",  // Temporary credentials
  "eventName": "CreateAccessKey",  // New access key (persistence)
  "eventName": "PutUserPolicy",  // Permission changes
  "eventName": "RunInstances",  // EC2 launched
  "eventName": "CreateFunction20150331",  // Lambda created
  "eventName": "PutBucketPolicy",  // S3 bucket exposed
  "eventName": "GetSecretValue",  // Secrets Manager access
  "eventName": "DescribeInstances",  // Reconnaissance
  "eventName": "ListBuckets",  // S3 enumeration
}
```

**Analysis Commands:**
```bash
# Failed API calls (reconnaissance)
jq '.Records[] | select(.errorCode != null) | {time: .eventTime, user: .userIdentity.principalId, action: .eventName, error: .errorCode}' cloudtrail.json

# API calls from external IPs
jq '.Records[] | select(.sourceIPAddress | test("^(?!10\\.|172\\.(1[6-9]|2[0-9]|3[01])\\.|192\\.168\\.)")) | {time: .eventTime, ip: .sourceIPAddress, action: .eventName}' cloudtrail.json

# IAM policy changes
jq '.Records[] | select(.eventName | test("Put.*Policy|Attach.*Policy|Create.*Policy")) | {time: .eventTime, user: .userIdentity.principalId, action: .eventName}' cloudtrail.json
```

### VPC Flow Logs
**Format:** `<version> <account-id> <interface-id> <srcaddr> <dstaddr> <srcport> <dstport> <protocol> <packets> <bytes> <start> <end> <action> <log-status>`

**Key Patterns:**
- Connections to external IPs on unusual ports
- Large data transfers (high bytes) to external destinations
- Rejected connections (port scanning)

### EC2 Instance Metadata
**Evidence from compromised instances:**
- Instance User Data: `curl http://169.254.169.254/latest/user-data`
- IAM Role credentials: `curl http://169.254.169.254/latest/meta-data/iam/security-credentials/<role>`
- Check CloudTrail for metadata service abuse

### S3 Access Logs
```
bucket-owner canonical-user-id [timestamp] remote-ip requester operation key "request-uri" http-status error-code bytes-sent object-size total-time turn-around-time "referer" "user-agent"
```
**Look for:**
- `ListBucket` from external IPs (enumeration)
- `GetObject` on sensitive files
- `PutObject` (data upload/exfiltration)

### Lambda Function Logs (CloudWatch)
```bash
aws logs filter-log-events --log-group-name /aws/lambda/<function> \
  --start-time <epoch_ms> --filter-pattern "ERROR"
```
**Check for:**
- Environment variables with secrets
- Invocation from unusual sources
- Code modifications: `aws lambda get-function --function-name <name>`

---

## Azure
### Activity Logs
**Location:** Azure Monitor → Activity Logs

**Critical Operations:**
- `Microsoft.Compute/virtualMachines/write` - VM created/modified
- `Microsoft.Authorization/roleAssignments/write` - Role assigned
- `Microsoft.KeyVault/vaults/secrets/read` - Secret accessed
- `Microsoft.Storage/storageAccounts/listKeys/action` - Storage keys retrieved

**Query via CLI:**
```bash
az monitor activity-log list --start-time 2024-01-01T00:00:00Z \
  --query "[?contains(operationName.value, 'roleAssignments')]"
```

### Sign-in Logs (Azure AD)
```bash
az ad signed-in-user list-sign-ins --query "[?status.errorCode != 0]"
```
**Check for:**
- Failed sign-ins (brute-force)
- Sign-ins from risky IPs/locations
- MFA bypass attempts

### NSG Flow Logs (Network Security Group)
**Format:** JSON in Storage Account
```json
{
  "time": "2024-01-15T10:30:00.000Z",
  "systemId": "...",
  "category": "NetworkSecurityGroupFlowEvent",
  "properties": {
    "flows": [
      {
        "rule": "AllowVnetInBound",
        "mac": "...",
        "flowTuples": [
          "1642243800,10.0.1.5,40.117.XXX.XXX,445,50000,T,I,D"
          // Format: timestamp,srcIP,dstIP,srcPort,dstPort,protocol,direction,action
        ]
      }
    ]
  }
}
```

### Azure Storage Analytics Logs
**Enable:** Storage Account → Monitoring → Diagnostic Settings
**Check for:**
- Anonymous access (`AuthenticationType: anonymous`)
- Mass downloads (`OperationName: GetBlob`)

---

## GCP
### Cloud Audit Logs
**Types:**
1. **Admin Activity** - Configuration changes (always on)
2. **Data Access** - Read/write operations (must enable)
3. **System Events** - GCP-initiated actions
4. **Policy Denied** - Access denied logs

**Key Events:**
```json
{
  "protoPayload": {
    "methodName": "v1.compute.instances.insert",  // VM created
    "methodName": "storage.buckets.getIamPolicy",  // IAM policy read
    "methodName": "iam.serviceAccounts.keys.create",  // Service account key
    "authenticationInfo": {
      "principalEmail": "attacker@evil.com"
    },
    "requestMetadata": {
      "callerIp": "203.0.113.45"
    }
  }
}
```

**Query via gcloud:**
```bash
gcloud logging read 'protoPayload.methodName=~".*iam.*"' \
  --limit 100 --format json --freshness=7d
```

### VPC Flow Logs
```json
{
  "connection": {
    "src_ip": "10.128.0.2",
    "src_port": 52000,
    "dest_ip": "203.0.113.45",
    "dest_port": 443,
    "protocol": 6
  },
  "start_time": "2024-01-15T10:30:00.000Z",
  "bytes_sent": 123456,
  "packets_sent": 100
}
```

### GCS (Storage) Access Logs
```bash
gsutil logging get gs://<bucket-name>
```

---

## Common Cloud Attack Patterns
### Metadata Service Abuse (SSRF → Credential Theft)
- **AWS:** `169.254.169.254/latest/meta-data/iam/security-credentials/`
- **Azure:** `169.254.169.254/metadata/identity/oauth2/token`
- **GCP:** `169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token`

**Evidence:**
- Web access logs with metadata IPs
- CloudTrail/Audit showing API calls from instance role shortly after web request

### IAM Privilege Escalation
**AWS Techniques:**
- `iam:PutUserPolicy` on self
- `iam:AttachUserPolicy` with `AdministratorAccess`
- `iam:PassRole` + `lambda:CreateFunction` (execute code as high-privilege role)

**Detection:**
- CloudTrail: Policy attachment events where `userIdentity` = `resources[].ARN`

### Persistence via Serverless
- **AWS Lambda:** Backdoor function with EventBridge schedule
- **Azure Functions:** Modified function code with timer trigger
- **GCP Cloud Functions:** HTTP trigger with public access

**Evidence:**
- Function creation/update events in audit logs
- Unusual invocation patterns in CloudWatch/Stackdriver

### Data Exfiltration via Cloud Storage
- S3 `cp` to attacker-controlled bucket
- Azure Storage `azcopy` to external account
- GCS `gsutil rsync` to public bucket

**Evidence:**
- Storage access logs showing large outbound transfers
- VPC Flow Logs: high bytes to cloud provider IP ranges
