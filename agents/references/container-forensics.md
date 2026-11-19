# Container & Kubernetes Forensics

## Docker Forensics
### Container Runtime Artifacts
**Locations:**
- `/var/lib/docker/containers/<container-id>/` - Container metadata
- `/var/lib/docker/overlay2/<layer-id>/` - Image layers
- `/var/lib/docker/image/overlay2/` - Image metadata

### Key Files to Examine
```bash
# Container config (command, env vars, mounts)
/var/lib/docker/containers/<id>/config.v2.json

# Container logs (stdout/stderr)
/var/lib/docker/containers/<id>/<id>-json.log

# Hostname mapping
/var/lib/docker/containers/<id>/hostname
/var/lib/docker/containers/<id>/hosts

# Mounted volumes
/var/lib/docker/volumes/<volume-name>/_data/
```

### Docker Daemon Logs
```bash
# systemd
journalctl -u docker.service -n 1000 --no-pager

# traditional logs
/var/log/docker.log
/var/log/syslog | grep docker
```

### Analysis Commands
```bash
# List all containers (including stopped)
docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.CreatedAt}}\t{{.Status}}"

# Inspect container (full JSON config)
docker inspect <container-id>

# View container logs
docker logs <container-id> --tail 1000

# Check image layers (look for suspicious commands)
docker history <image-id> --no-trunc

# Extract files from stopped container
docker cp <container-id>:/path/to/file ./output/

# Deep image layer analysis
docker save <image-id> -o image.tar
tar -xf image.tar
# Examine layer.tar files
```

### Indicators of Compromise
- **Privileged containers:** `"Privileged": true` in `config.v2.json`
- **Host mounts:** `/var/run/docker.sock`, `/`, `/etc`, `/proc` mounted
- **Suspicious capabilities:** `CAP_SYS_ADMIN`, `CAP_SYS_PTRACE`
- **Host network mode:** `"NetworkMode": "host"`
- **PID namespace sharing:** `"PidMode": "host"`

### Registry Credentials
```bash
# Docker config (contains registry auth tokens)
~/.docker/config.json
/root/.docker/config.json

# Decode base64 auth
jq -r '.auths."https://index.docker.io/v1/".auth' ~/.docker/config.json | base64 -d
```

---

## Kubernetes Forensics
### Cluster-Level Artifacts
**Locations (Control Plane):**
- `/var/log/kube-apiserver.log` - API server access logs
- `/var/log/kube-controller-manager.log` - Controller operations
- `/var/log/kube-scheduler.log` - Pod scheduling decisions
- `/var/log/kubernetes/audit/audit.log` - **CRITICAL: All API operations**

### Pod-Level Artifacts
```bash
# Pod logs
kubectl logs <pod-name> -n <namespace> --previous  # Logs from crashed container

# Exec history (if audit logging enabled)
kubectl get events -n <namespace> | grep exec

# Pod specification
kubectl get pod <pod-name> -n <namespace> -o yaml

# All resources in namespace
kubectl get all -n <namespace> -o yaml > namespace-dump.yaml
```

### Kubernetes Audit Logs
**Enable:** API server flag `--audit-log-path=/var/log/kubernetes/audit/audit.log`

**Critical Events:**
```json
{
  "verb": "create",
  "objectRef": {
    "resource": "pods",
    "namespace": "default",
    "name": "evil-pod"
  },
  "user": {
    "username": "system:serviceaccount:default:default",
    "uid": "..."
  },
  "sourceIPs": ["10.0.1.5"],
  "requestObject": {
    "spec": {
      "hostNetwork": true,  // RED FLAG
      "containers": [{
        "securityContext": {
          "privileged": true  // RED FLAG
        }
      }]
    }
  }
}
```

**Key verbs to search:**
- `create pods` with `hostPath`, `hostNetwork`, `privileged`
- `get secrets` - Credential access
- `exec` - Command execution in pods
- `portforward` - Tunneling
- `create serviceaccounts` - Persistence
- `create clusterrolebindings` - Privilege escalation

### RBAC Analysis
```bash
# Check what a service account can do
kubectl auth can-i --list --as=system:serviceaccount:default:default

# Find overly permissive bindings
kubectl get clusterrolebindings -o json | jq '.items[] | select(.subjects[]?.name == "system:anonymous")'

# List all service accounts with cluster-admin
kubectl get clusterrolebindings -o json | jq '.items[] | select(.roleRef.name == "cluster-admin") | .subjects'
```

### Secrets & Credentials
```bash
# List all secrets
kubectl get secrets -A -o json > all-secrets.json

# Decode secret (Base64)
kubectl get secret <secret-name> -n <namespace> -o jsonpath='{.data.password}' | base64 -d

# Service account tokens (auto-mounted in pods)
# Location inside pod: /var/run/secrets/kubernetes.io/serviceaccount/token
```

### Pod Security Issues
**Check for:**
```yaml
# Privileged container
securityContext:
  privileged: true

# Host filesystem access
volumes:
- name: host-root
  hostPath:
    path: /

# Host network
hostNetwork: true

# Host PID namespace
hostPID: true

# Unrestricted capabilities
securityContext:
  capabilities:
    add:
    - SYS_ADMIN
    - NET_ADMIN
```

### etcd Forensics (WARNING: Contains ALL secrets)
**Location:** Usually `/var/lib/etcd/`

```bash
# Dump all keys (requires etcdctl)
ETCDCTL_API=3 etcdctl get / --prefix --keys-only

# Get all secrets
ETCDCTL_API=3 etcdctl get /registry/secrets/ --prefix

# Backup entire etcd
ETCDCTL_API=3 etcdctl snapshot save etcd-backup.db
```

### Network Policies
```bash
# Check if NetworkPolicies exist (otherwise all traffic allowed)
kubectl get networkpolicies -A

# Analyze policies
kubectl get networkpolicy <policy-name> -o yaml
```

---

## Container Escape Detection
### Common Techniques
1. **Docker Socket Abuse:**
   ```bash
   # If /var/run/docker.sock mounted
   docker -H unix:///var/run/docker.sock run -v /:/host --privileged alpine chroot /host
   ```
   **Evidence:** Audit logs showing `docker run` from container, new privileged container created

2. **Privileged Container → Host:**
   ```bash
   # Mount host filesystem via /proc/1/root
   nsenter --target 1 --mount --uts --ipc --net --pid -- /bin/bash
   ```
   **Evidence:** `nsenter` process in container logs

3. **Kernel Exploits (DirtyPipe, etc.):**
   **Evidence:** Kernel version in `uname -r`, exploit artifacts in `/tmp`

4. **Kubernetes Node Compromise:**
   ```bash
   # Via hostPath volume
   kubectl exec -it <pod> -- chroot /host-root /bin/bash
   ```
   **Evidence:** Pod with `hostPath: /` in spec, exec commands in audit logs

---

## Container Image Analysis
### Dive Tool (Layer Inspection)
```bash
dive <image-name>
```
**Look for:**
- Secrets in layers (even deleted files persist in layers)
- Cryptominers (`xmrig`, `minerd`)
- Reverse shell scripts
- Suspicious network tools (`nmap`, `chisel`, `socat`)

### Trivy (Vulnerability Scanning)
```bash
trivy image <image-name>
```
**Check for:**
- High/Critical CVEs in base image
- Secrets detected in layers

### Manual Layer Inspection
```bash
docker save <image> -o image.tar
tar -xf image.tar

# Each layer is a tar.gz
cd <layer-sha>/
tar -xzf layer.tar.gz
# Examine filesystem
```

---

## Kubernetes Incident Response Playbook
### 1. Immediate Containment
```bash
# Isolate pod (deny all traffic)
kubectl label pod <pod-name> quarantine=true
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: quarantine
spec:
  podSelector:
    matchLabels:
      quarantine: "true"
  policyTypes:
  - Ingress
  - Egress
EOF

# Delete malicious pod
kubectl delete pod <pod-name> -n <namespace>

# Cordon node (prevent new pods)
kubectl cordon <node-name>
```

### 2. Evidence Collection
```bash
# Dump pod spec
kubectl get pod <pod-name> -n <namespace> -o yaml > pod-spec.yaml

# Get logs
kubectl logs <pod-name> -n <namespace> --all-containers --previous > pod-logs.txt

# Get events
kubectl get events -n <namespace> --sort-by='.lastTimestamp' > events.txt

# Describe pod
kubectl describe pod <pod-name> -n <namespace> > pod-describe.txt
```

### 3. Check All Clusters
```bash
# Find suspicious pods across all namespaces
kubectl get pods -A -o json | jq '.items[] | select(.spec.hostNetwork == true or .spec.hostPID == true or .spec.containers[].securityContext.privileged == true) | {namespace: .metadata.namespace, pod: .metadata.name}'
```
