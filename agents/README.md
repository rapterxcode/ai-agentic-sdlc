# Custom Agents & Tool Permissions Matrix

เอกสารสรุปบทบาทและสิทธิ์การใช้เครื่องมือ (`tools:` ใน YAML Frontmatter) ของ Custom Agents ทั้ง 12 ตัวใน `~/.gemini/config/agents/` สำหรับ **Antigravity (`agy`)**

> **หมายเหตุสำคัญ:**
> 1. ใน Antigravity หากไฟล์ `agent.md` ไม่ได้ประกาศฟิลด์ `tools:` ใน YAML Frontmatter ระบบจะจำกัดให้เหลือเฉพาะชุด Default Read-Only เท่านั้น (ไม่มี `write_file`, `edit_file`, `run_command`) ดังนั้นทุก Agent จึงต้องระบุ `tools:` อย่างชัดเจนตามบทบาท
> 2. เครื่องมือของ MCP (`list_resources`, `read_resource`, `call_mcp_tool` และ Eager MCP tools) **ห้ามระบุตรงๆ ใน `tools:`** (ไม่อยู่ใน Static Component Registry) แต่ให้เปิดผ่าน `inheritMcp: true` ใน YAML Frontmatter เพื่อให้ `MCPLoader` inject เข้าสู่ Agent โดยอัตโนมัติ

---

## 1. ชุดเครื่องมือพื้นฐานร่วม (Base Toolset — มีครบทั้ง 12 Agents)

| Tool ID / Frontmatter | หน้าที่ |
|---|---|
| `read_file` | อ่านเนื้อหาไฟล์โค้ด, Log, Config, รูปภาพ และเอกสาร PDF |
| `run_command` | รันคำสั่ง Shell, Test suite (`pytest`/`vitest`/`playwright`), Linter, Git และ Security scanner |
| `manage_task` | จัดการ Background process (`list`, `status`, `send_input`, `kill`) |
| `search_web` | ค้นหาเอกสารทางการ, CVE, API Reference จากภายนอก |
| `ask_question` | ถามคำถามแบบตัวเลือกกับผู้ใช้เมื่อ Requirement หรือขอบเขตไม่ชัดเจน |
| `send_message` | ส่งข้อความตอบกลับ/ประสานงานระหว่าง Main Agent และ Subagent |
| `inheritMcp: true` *(Frontmatter)* | เปิดให้ `MCPLoader` โหลด `list_resources`, `read_resource`, `call_mcp_tool` และ MCP Servers (เช่น `stitch`, `codegraph`, DB/Cloud MCP) โดยอัตโนมัติ |

---

## 2. ตารางสิทธิ์เครื่องมือรายบุคคล (Per-Agent Tool Matrix)

| # | Agent | ไฟล์กำหนดค่า | `write_file` | `edit_file` | `invoke_subagent` + `manage_subagents` | เครื่องมือเฉพาะทางเพิ่มเติม | ขอบเขตการใช้งานหลัก |
|---|---|---|---|---|:---:|:---:|:---|
| 1 | **`agent-pm-ba`** | `agent-pm-ba/agent.md` | ✅ | ✅ | ✅ | — | เขียน/แก้ไข PRD, User Stories, Acceptance Criteria (`docs/`, `specs/`), รัน `grep`/`markdownlint`, ส่งต่อ Architect/QA |
| 2 | **`agent-architect-tech-lead`** | `agent-architect-tech-lead/agent.md` | ✅ | ✅ | ✅ | `run_workflow`, `schedule` | ออกแบบสถาปัตยกรรม, API Contract, ADR, รันตรวจ OpenAPI/Terraform และกระจายงานให้ทีม Specialist |
| 3 | **`agent-backend-senior`** | `agent-backend-senior/agent.md` | ✅ | ✅ | ✅ | — | พัฒนา API, Service, Repository, Worker + รัน Linter/Typecheck/Tests และประสาน DBA/Pentester/Reviewer |
| 4 | **`agent-frontend-senior`** | `agent-frontend-senior/agent.md` | ✅ | ✅ | ✅ | `generate_image` | พัฒนา Web UI, State, Accessibility, Playwright E2E + สร้าง Asset ภาพประกอบร่วมกับ MCP `stitch` |
| 5 | **`agent-fullstack-senior`** | `agent-fullstack-senior/agent.md` | ✅ | ✅ | ✅ | `generate_image` | พัฒนา Feature แบบ End-to-End (DB → Backend → Frontend → Tests) พร้อมสร้าง UI Asset และเรียกทีมตรวจ |
| 6 | **`agent-dba-data-engineer`** | `agent-dba-data-engineer/agent.md` | ✅ | ✅ | ✅ | — | ออกแบบ Schema, Zero-downtime Migration, ETL/dbt และรัน `EXPLAIN ANALYZE` / `sqlfluff` / `alembic` |
| 7 | **`agent-devsecops-sre`** | `agent-devsecops-sre/agent.md` | ✅ | ✅ | ✅ | `schedule` | ดูแล CI/CD, Dockerfile, K8s, Terraform, รัน `trivy`/`actionlint`/`terraform plan` และตั้งเวลาเช็ก Rollout |
| 8 | **`agent-qa-automation`** | `agent-qa-automation/agent.md` | ✅ | ✅ | ❌ | — | เขียนและรัน Automated Tests (Unit, Integration, API, Playwright E2E) พร้อมตรวจ Flakiness |
| 9 | **`agent-whitehacker-close-backdoor`** | `agent-whitehacker-close-backdoor/agent.md` | ✅ | ✅ | ✅ | — | ตรวจหา Backdoor/Persistence และลงมือ Patch ปิดช่องโหว่ระดับ Root Cause พร้อมเขียน Security Regression Tests |
| 10 | **`agent-pentester-security`** | `agent-pentester-security/agent.md` | ✅ | ✅ | ❌ | — | ตรวจช่องโหว่เชิงรุก (SAST/Config/AuthZ/CVE ด้วย `gitleaks`/`semgrep`/`trivy`) และเขียน/อัปเดตไฟล์ Security Audit Report หรือ PoC |
| 11 | **`agent-rca`** | `agent-rca/agent.md` | ✅ | ❌ | ❌ | — | วิเคราะห์หลักฐาน DFIR แบบ Static (`tar`/`sha256sum`/`strings`/`grep`) และสร้างไฟล์รายงาน RCA โดยไม่แก้ไขไฟล์หลักฐานเดิม |
| 12 | **`agent-code-reviewer`** | `agent-code-reviewer/agent.md` | ✅ | ✅ | ❌ | — | ตรวจ Pull Request / `git diff` + รัน Test พิสูจน์จริง และเขียน/อัปเดตไฟล์ Review Report (ห้ามแก้ Production code ตามกฎใน Prompt) |

---

## 3. การเรียกใช้งานผ่าน CLI (`agy`)

```bash
# ดูรายชื่อ Agents ทั้งหมดที่ระบบโหลดได้
agy agents

# เปิดใช้งาน Agent ตัวใดตัวหนึ่งเป็น Main Agent โดยตรง
agy --agent agent-backend-senior
agy --agent agent-architect-tech-lead
```
