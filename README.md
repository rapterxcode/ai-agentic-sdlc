<!-- AI_TEAM_GLOBAL_RULE_START -->
<!-- Do not edit or modify this block manually. It is managed by automated installation engines. -->
<!-- AI_TEAM_GLOBAL_RULE_END -->

<div align="center">

# 🤖 pasitc-ai-agents-skills

### Supercharge your AI Coding Companions with 64+ Curated Skills & Multi-Agent SDLC Workflows

[![Claude Code](https://img.shields.io/badge/Claude%20Code-v2.1-orange?style=for-the-badge&logo=anthropic&logoColor=white)](https://code.claude.com)
[![Kiro CLI](https://img.shields.io/badge/Kiro%20CLI-v2.13-emerald?style=for-the-badge&logo=robot&logoColor=white)](https://github.com)
[![Codex CLI](https://img.shields.io/badge/Codex%20CLI-v0.144-blue?style=for-the-badge&logo=terminal&logoColor=white)](https://github.com)
[![Gemini CLI](https://img.shields.io/badge/Gemini%20CLI-v0.51-violet?style=for-the-badge&logo=google-gemini&logoColor=white)](https://github.com)
<br>
[![Total Skills](https://img.shields.io/badge/Curated_Skills-64%2B-cyan?style=flat-square)](./skills)
[![Specialists](https://img.shields.io/badge/Specialist_Agents-10-purple?style=flat-square)](./agents)
[![SDLC Workflow](https://img.shields.io/badge/SDLC_Workflow-10_Phases-amber?style=flat-square)](./docs/WORKFLOW.md)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](./LICENSE)

---

### 🌐 [คลิกเพื่อเปิด Interactive HTML Landing Page (index.html)](./index.html)
*ดาวน์โหลดหรือเปิดไฟล์ `index.html` บนบราวเซอร์ของคุณเพื่อสัมผัสประสบการณ์พอร์ทัลแบบโต้ตอบ แอนิเมชันสวยงาม พร้อมแท็บสลับคำสั่งติดตั้งอัจฉริยะ*

---

</div>

## 📌 Repository นี้คืออะไร? (What is this?)

**pasitc-ai-agents-skills** คือ คอลเลกชันระดับมืออาชีพที่รวบรวม **AI Skills (ความสามารถเฉพาะทาง)**, **Multi-Agent Rosters (ทำเนียบเอเจนท์)** และ **Canonical SDLC Delivery Workflows** ที่ออกแบบและพัฒนาโดย pasitc สำหรับสนับสนุนโปรแกรมเมอร์ในการทำงานร่วมกับ AI Coding CLI ยุคใหม่ (ปี 2026) 

โปรเจกต์นี้รองรับแพลตฟอร์ม AI CLI ชั้นนำทั้ง 4 ตัว ได้แก่ **Claude Code**, **Kiro CLI**, **Codex CLI**, และ **Gemini CLI (Antigravity)** โดยมุ่งเน้นการยกระดับความเร็ว คุณภาพของโค้ด และสร้างวินัยในการตรวจสอบที่เคร่งครัดระดับโปรดักชัน

### 🌟 ฟีเจอร์หลัก (Core Features)
1. **64 Curated Skills:** ความสามารถเฉพาะทาง 64 รายการจากคลังโอเพนซอร์สชั้นนำ 5 แห่ง (9arm, Matt Pocock, Andrej Karpathy, Loop Engineering และ Superpowers)
2. **Multi-Agent Orchestration:** ทีม AI ทำงานประสานกันผ่านเอเจนท์หลัก `aidlc-lead` / `team-leader` และเอเจนท์เฉพาะทาง (Specialist) อีก 8 ตัว
3. **10-Phase SDLC Workflow (AIDLC-lite):** กระบวนการวางแผน พัฒนา ทดสอบ และตรวจสอบความปลอดภัยแบบ End-to-End
4. **Local Offline Vendors:** รวมแพ็คเกจเสริมฉบับเต็มของ Superpowers, Ponytail และ Obsidian Second Brain ในตัว ไม่ต้องดาวน์โหลดจากภายนอก

---

## 🔄 การทำงานอย่างไร? (How it works & Multi-Agent Architecture)

การทำงานของระบบขับเคลื่อนด้วยทีม **Multi-Agent** ที่จัดวางหน้าที่การรับผิดชอบอย่างชัดเจน โดยมี **`aidlc-lead`** ทำหน้าที่เป็นผู้ประสานงานหลัก (Orchestrator) คอยรับคำสั่งจากผู้ใช้ วางแผน และมอบหมายงานเชิงลึกให้เอเจนท์เฉพาะทาง (Specialist Sub-agents) 

กระบวนการทั้งหมดถูกควบคุมด้วยกรอบขั้นตอน **AIDLC-lite 10-Phase SDLC Workflow** เพื่อรับประกันคุณภาพสูงสุด:

### 📊 แผนผังการทำงาน (AIDLC-lite Columnar Workflow Diagram)

```xml
<!-- Embedded SVG Flowchart: High resolution Columnar Flow with glowing neon gradients -->
<svg viewBox="0 0 1150 650" width="100%" height="auto" xmlns="http://www.w3.org/2000/svg" style="background:#070a13; border-radius:16px; border:1px solid rgba(255,255,255,0.08); box-shadow: 0 15px 35px rgba(0,0,0,0.6);">
    <defs>
        <!-- Gradients -->
        <linearGradient id="g-lead" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stop-color="#059669" />
            <stop offset="100%" stop-color="#10b981" />
        </linearGradient>
        <linearGradient id="g-agent" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stop-color="#1d4ed8" />
            <stop offset="100%" stop-color="#0ea5e9" />
        </linearGradient>
        <linearGradient id="g-human" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stop-color="#d97706" />
            <stop offset="100%" stop-color="#f59e0b" />
        </linearGradient>
        <linearGradient id="g-phase" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stop-color="#6d28d9" />
            <stop offset="100%" stop-color="#a855f7" />
        </linearGradient>
        <linearGradient id="g-col" x1="0%" y1="0%" x2="0%" y2="100%">
            <stop offset="0%" stop-color="rgba(255,255,255,0.02)" />
            <stop offset="100%" stop-color="rgba(255,255,255,0.0)" />
        </linearGradient>

        <!-- Neon Glow Filters -->
        <filter id="f-glow" x="-10%" y="-10%" width="120%" height="120%">
            <feGaussianBlur stdDeviation="4" result="blur" />
            <feComposite in="SourceGraphic" in2="blur" operator="over" />
        </filter>

        <!-- Arrow Markers -->
        <marker id="arrow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M0,1 L10,5 L0,9 z" fill="#64748b" />
        </marker>
        <marker id="arrow-glow" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M0,1 L10,5 L0,9 z" fill="#0ea5e9" />
        </marker>
        <marker id="arrow-green" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
            <path d="M0,1 L10,5 L0,9 z" fill="#10b981" />
        </marker>
    </defs>

    <!-- Grid background -->
    <rect width="100%" height="100%" fill="#070a13" rx="16" />
    <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
        <path d="M 40 0 L 0 0 0 40" fill="none" stroke="rgba(255, 255, 255, 0.015)" stroke-width="1" />
    </pattern>
    <rect width="100%" height="100%" rx="16" fill="url(#grid)" />

    <!-- 4 Core Columns Boundaries -->
    <g font-family="system-ui, sans-serif" font-size="11" font-weight="bold" fill="rgba(255,255,255,0.15)">
        <!-- Col 1: Analyze & Design -->
        <rect x="15" y="15" width="280" height="620" rx="12" fill="url(#g-col)" stroke="rgba(255,255,255,0.05)" />
        <text x="155" y="40" text-anchor="middle" letter-spacing="1">1. ANALYZE &amp; DESIGN</text>

        <!-- Col 2: Plan & Validate -->
        <rect x="310" y="15" width="250" height="620" rx="12" fill="url(#g-col)" stroke="rgba(255,255,255,0.05)" />
        <text x="435" y="40" text-anchor="middle" letter-spacing="1">2. PLAN &amp; VALIDATE</text>

        <!-- Col 3: Execute & Audit -->
        <rect x="575" y="15" width="310" height="620" rx="12" fill="url(#g-col)" stroke="rgba(255,255,255,0.05)" />
        <text x="730" y="40" text-anchor="middle" letter-spacing="1">3. EXECUTE &amp; AUDIT</text>

        <!-- Col 4: Deliver & Operate -->
        <rect x="900" y="15" width="235" height="620" rx="12" fill="url(#g-col)" stroke="rgba(255,255,255,0.05)" />
        <text x="1017" y="40" text-anchor="middle" letter-spacing="1">4. DELIVER &amp; OPERATE</text>
    </g>

    <!-- Legend -->
    <g transform="translate(30, 595)" font-size="10" font-weight="bold" font-family="system-ui, sans-serif">
        <rect x="0" y="0" width="100" height="22" rx="4" fill="url(#g-lead)" />
        <text x="50" y="14" fill="white" text-anchor="middle">Orchestrator</text>

        <rect x="110" y="0" width="100" height="22" rx="4" fill="url(#g-agent)" />
        <text x="160" y="14" fill="white" text-anchor="middle">Specialist Agent</text>

        <rect x="220" y="0" width="100" height="22" rx="4" fill="url(#g-human)" />
        <text x="270" y="14" fill="white" text-anchor="middle">Human Gate</text>

        <rect x="330" y="0" width="100" height="22" rx="4" fill="url(#g-phase)" />
        <text x="380" y="14" fill="white" text-anchor="middle">SDLC Phase</text>
    </g>

    <!-- Connector Paths (Curved Bezier Lines) -->
    <!-- Start to Orchestrator -->
    <path d="M 155,105 L 155,140" stroke="#0ea5e9" stroke-width="2" marker-end="url(#arrow-glow)" />
    <!-- Orchestrator to Phase 0 -->
    <path d="M 155,210 L 155,250" stroke="#10b981" stroke-width="2.5" marker-end="url(#arrow-green)" />
    <!-- Phase 0 to Phase 1 -->
    <path d="M 155,300 L 155,340" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />
    <!-- Phase 1 to researcher (Bidirectional) -->
    <path d="M 155,390 C 155,420 155,440 155,460" stroke="#0ea5e9" stroke-width="1.5" stroke-dasharray="3,3" />
    <path d="M 155,460 C 155,440 155,420 155,390" stroke="#0ea5e9" stroke-width="1.5" stroke-dasharray="3,3" marker-end="url(#arrow-glow)" />
    
    <!-- Phase 1 to Phase 2/3 (Column crossing) -->
    <path d="M 225,365 C 265,365 240,115 285,115 L 340,115" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />
    <!-- Phase 2/3 to Gate A -->
    <path d="M 435,140 L 435,180" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />
    <!-- Gate A to Phase 4 -->
    <path d="M 435,230 L 435,270" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />
    <!-- Phase 4 to Gate 1 (plan-reviewer) -->
    <path d="M 435,320 L 435,360" stroke="#0ea5e9" stroke-width="1.5" marker-end="url(#arrow-glow)" />
    <!-- Revise loop (Gate 1 to Phase 4) -->
    <path d="M 495,385 C 525,385 525,295 495,295" stroke="#f59e0b" stroke-width="1.5" stroke-dasharray="2,2" marker-end="url(#arrow)" />
    <text x="525" y="345" fill="#f59e0b" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle" font-weight="bold">Revise Plan</text>
    <!-- Gate 1 to Gate B -->
    <path d="M 435,415 L 435,450" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />

    <!-- Gate B to Phase 5 (Column crossing) -->
    <path d="M 495,475 C 555,475 525,115 585,115 L 670,115" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />
    <!-- Phase 5 to Specialists (Bidirectional) -->
    <path d="M 790,115 L 820,115" stroke="#0ea5e9" stroke-width="1.5" stroke-dasharray="3,3" marker-end="url(#arrow-glow)" />
    <path d="M 820,130 L 790,130" stroke="#0ea5e9" stroke-width="1.5" stroke-dasharray="3,3" marker-end="url(#arrow-glow)" />
    <!-- Phase 5 to Gate 2 (security-auditor) -->
    <path d="M 730,140 L 730,180" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />
    <!-- Gate 2 to Phase 6 -->
    <path d="M 730,230 L 730,270" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />
    <!-- Phase 6 to Phase 7 -->
    <path d="M 730,320 L 730,360" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />
    <!-- Phase 7 to Gate 3 / Gate 4 (Bidirectional) -->
    <path d="M 790,385 L 820,385" stroke="#0ea5e9" stroke-width="1.5" stroke-dasharray="3,3" marker-end="url(#arrow-glow)" />
    <path d="M 790,405 L 820,465" stroke="#0ea5e9" stroke-width="1.5" stroke-dasharray="3,3" marker-end="url(#arrow-glow)" />

    <!-- Phase 7 to Phase 8 (Column crossing) -->
    <path d="M 730,410 C 730,440 730,470 700,500 L 700,530 C 700,560 880,560 920,475 C 930,450 930,125 960,115 L 980,115" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />
    <!-- Phase 8 to Gate C -->
    <path d="M 1035,140 L 1035,180" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)" />
    <!-- Gate C to Phase 9 -->
    <path d="M 1035,230 L 1035,270" stroke="#10b981" stroke-width="2" marker-end="url(#m-arrow-green)" />

    <!-- NODES -->
    <!-- Column 1: Analyze & Design -->
    <g transform="translate(100, 65)">
        <rect x="0" y="0" width="110" height="40" rx="8" fill="#1e293b" stroke="#0ea5e9" stroke-width="2" />
        <text x="55" y="24" fill="white" font-family="monospace" font-size="12" font-weight="bold" text-anchor="middle">/aidlc task</text>
    </g>

    <g transform="translate(100, 140)">
        <rect x="0" y="0" width="110" height="70" rx="12" fill="url(#g-lead)" stroke="#34d399" stroke-width="2.5" filter="url(#f-glow)" />
        <text x="55" y="32" fill="white" font-family="system-ui, sans-serif" font-size="13" font-weight="extrabold" text-anchor="middle">aidlc-lead</text>
        <text x="55" y="50" fill="#a7f3d0" font-family="system-ui, sans-serif" font-size="10" font-weight="bold" text-anchor="middle">Orchestrator</text>
    </g>

    <g transform="translate(85, 250)">
        <rect x="0" y="0" width="140" height="50" rx="10" fill="url(#g-phase)" stroke="#c084fc" stroke-width="1" />
        <text x="70" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="bold" text-anchor="middle">Phase 0</text>
        <text x="70" y="40" fill="#e9d5ff" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Classify Scope</text>
    </g>

    <g transform="translate(85, 340)">
        <rect x="0" y="0" width="140" height="50" rx="10" fill="url(#g-phase)" stroke="#c084fc" stroke-width="1" />
        <text x="70" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="bold" text-anchor="middle">Phase 1</text>
        <text x="70" y="40" fill="#e9d5ff" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Establish Context</text>
    </g>

    <g transform="translate(100, 460)">
        <rect x="0" y="0" width="110" height="40" rx="8" fill="url(#g-agent)" stroke="#38bdf8" stroke-width="1" />
        <text x="55" y="24" fill="white" font-family="system-ui, sans-serif" font-size="11" font-weight="bold" text-anchor="middle">researcher</text>
    </g>

    <!-- Column 2: Plan & Validate -->
    <g transform="translate(340, 90)">
        <rect x="0" y="0" width="190" height="50" rx="10" fill="url(#g-phase)" stroke="#c084fc" stroke-width="1" />
        <text x="95" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="bold" text-anchor="middle">Phase 2 &amp; 3</text>
        <text x="95" y="40" fill="#e9d5ff" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Requirements &amp; Design</text>
    </g>

    <g transform="translate(380, 180)">
        <rect x="0" y="0" width="110" height="50" rx="10" fill="url(#g-human)" stroke="#fbbf24" stroke-width="1.5" />
        <text x="55" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="extrabold" text-anchor="middle">Gate A</text>
        <text x="55" y="40" fill="#fde68a" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Approve Design</text>
    </g>

    <g transform="translate(365, 270)">
        <rect x="0" y="0" width="140" height="50" rx="10" fill="url(#g-phase)" stroke="#c084fc" stroke-width="1" />
        <text x="70" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="bold" text-anchor="middle">Phase 4</text>
        <text x="70" y="40" fill="#e9d5ff" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Plan &amp; Traceability</text>
    </g>

    <g transform="translate(380, 360)">
        <rect x="0" y="0" width="110" height="55" rx="10" fill="url(#g-agent)" stroke="#38bdf8" stroke-width="1.5" filter="url(#f-glow)" />
        <text x="55" y="24" fill="white" font-family="system-ui, sans-serif" font-size="11" font-weight="extrabold" text-anchor="middle">plan-reviewer</text>
        <text x="55" y="40" fill="#bae6fd" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Gate 1 Approve</text>
    </g>

    <g transform="translate(380, 450)">
        <rect x="0" y="0" width="110" height="50" rx="10" fill="url(#g-human)" stroke="#fbbf24" stroke-width="1.5" />
        <text x="55" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="extrabold" text-anchor="middle">Gate B</text>
        <text x="55" y="40" fill="#fde68a" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Approve Plan</text>
    </g>

    <!-- Column 3: Execute & Audit -->
    <g transform="translate(610, 90)">
        <rect x="0" y="0" width="180" height="50" rx="10" fill="url(#g-phase)" stroke="#c084fc" stroke-width="1" />
        <text x="90" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="bold" text-anchor="middle">Phase 5</text>
        <text x="90" y="40" fill="#e9d5ff" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Implement (TDD)</text>
    </g>

    <!-- Execution Specialist Team -->
    <g transform="translate(820, 85)">
        <rect x="0" y="0" width="50" height="50" rx="8" fill="rgba(14,165,233,0.1)" stroke="#38bdf8" stroke-width="1" />
        <text x="25" y="28" fill="#bae6fd" font-family="monospace" font-size="15" font-weight="bold" text-anchor="middle">ENG</text>
        <!-- Custom label pointing to team roster -->
        <text x="25" y="42" fill="white" font-family="system-ui, sans-serif" font-size="8" font-weight="bold" text-anchor="middle">Specialists</text>
    </g>

    <g transform="translate(645, 180)">
        <rect x="0" y="0" width="110" height="50" rx="10" fill="url(#g-agent)" stroke="#38bdf8" stroke-width="1" />
        <text x="55" y="24" fill="white" font-family="system-ui, sans-serif" font-size="10" font-weight="bold" text-anchor="middle">security-auditor</text>
        <text x="55" y="38" fill="#bae6fd" font-family="system-ui, sans-serif" font-size="9" text-anchor="middle">Gate 2 Security</text>
    </g>

    <g transform="translate(630, 270)">
        <rect x="0" y="0" width="140" height="50" rx="10" fill="url(#g-phase)" stroke="#c084fc" stroke-width="1" />
        <text x="70" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="bold" text-anchor="middle">Phase 6</text>
        <text x="70" y="40" fill="#e9d5ff" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Review Code</text>
    </g>

    <g transform="translate(630, 360)">
        <rect x="0" y="0" width="140" height="50" rx="10" fill="url(#g-phase)" stroke="#c084fc" stroke-width="1" />
        <text x="70" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="bold" text-anchor="middle">Phase 7</text>
        <text x="70" y="40" fill="#e9d5ff" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Build &amp; Verify</text>
    </g>

    <!-- Gate 3 and Gate 4 sub-agents -->
    <g transform="translate(820, 360)">
        <rect x="0" y="0" width="55" height="40" rx="6" fill="url(#g-agent)" stroke="#38bdf8" stroke-width="1" />
        <text x="27.5" y="22" fill="white" font-family="system-ui, sans-serif" font-size="8" font-weight="bold" text-anchor="middle">devsecops</text>
        <text x="27.5" y="32" fill="#bae6fd" font-family="system-ui, sans-serif" font-size="7" text-anchor="middle">Gate 3</text>
    </g>

    <g transform="translate(820, 440)">
        <rect x="0" y="0" width="55" height="40" rx="6" fill="url(#g-agent)" stroke="#38bdf8" stroke-width="1" />
        <text x="27.5" y="22" fill="white" font-family="system-ui, sans-serif" font-size="8" font-weight="bold" text-anchor="middle">test-auditor</text>
        <text x="27.5" y="32" fill="#bae6fd" font-family="system-ui, sans-serif" font-size="7" text-anchor="middle">Gate 4</text>
    </g>

    <!-- Column 4: Deliver & Operate -->
    <g transform="translate(930, 90)">
        <rect x="0" y="0" width="140" height="50" rx="10" fill="url(#g-phase)" stroke="#c084fc" stroke-width="1" />
        <text x="70" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="bold" text-anchor="middle">Phase 8</text>
        <text x="70" y="40" fill="#e9d5ff" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Release Readiness</text>
    </g>

    <g transform="translate(945, 180)">
        <rect x="0" y="0" width="110" height="50" rx="10" fill="url(#g-human)" stroke="#fbbf24" stroke-width="1.5" />
        <text x="55" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="extrabold" text-anchor="middle">Gate C</text>
        <text x="55" y="40" fill="#fde68a" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Prod Approval</text>
    </g>

    <g transform="translate(935, 270)">
        <rect x="0" y="0" width="130" height="50" rx="10" fill="url(#g-lead)" stroke="#34d399" stroke-width="1.5" />
        <text x="65" y="24" fill="white" font-family="system-ui, sans-serif" font-size="12" font-weight="extrabold" text-anchor="middle">Phase 9</text>
        <text x="65" y="40" fill="#a7f3d0" font-family="system-ui, sans-serif" font-size="10" text-anchor="middle">Ops &amp; Handoff</text>
    </g>
</svg>
```

<details>
<summary><b>📖 คลิกเพื่อดูคำอธิบายขั้นตอนโดยละเอียด (10-Phase Breakdown)</b></summary>
<br>

*   **Phase 0: เลือก Scope งาน** — เอเจนท์จำแนกประเภทงานเป็น `new`, `feature`, `bugfix`, `refactor` หรือ `investigation` และประเมินความซับซ้อนเพื่อพิจารณาการย่อยงาน
*   **Phase 1: ค้นหาความจริงใน Codebase** — สำรวจไฟล์ โค้ด และโครงสร้างเพื่อสรุปบริบท และเรียกใช้ `researcher` ช่วยสำรวจเชิงลึกแบบประหยัดโทเคน
*   **Phase 2: ตั้งสเปกความต้องการ (Requirements)** — สรุปเคสการใช้งานและเกณฑ์การทดสอบที่รัดกุม
*   **Phase 3: ออกแบบเชิงเทคนิค (Technical Design)** — เสนอแผนออกแบบและสถาปัตยกรรม และหยุดรอรับการอนุมัติที่ **Gate A (Human Approval)**
*   **Phase 4: เขียนแผนงานและตรวจสอบ** — ลงรายการแผนงานเป็นข้อย่อยๆ ส่งให้ `plan-reviewer` (**Gate 1**) ตรวจสอบความถูกต้อง เมื่อผ่านแล้วจะหยุดรอให้มนุษย์อนุมัติที่ **Gate B** ก่อนเริ่มเขียนโค้ด
*   **Phase 5: ลงมือพัฒนาด้วย TDD** — พัฒนาโค้ดแบบทีละไฟล์ ควบคู่กับการรันเทส หากงานแตะต้องความปลอดภัยหรือ Secrets จะส่งผ่านความเห็นจาก `security-auditor` (**Gate 2**)
*   **Phase 6: ตรวจสอบย้อนหลัง** — ตรวจสอบคุณภาพโค้ด คอนเวนชัน และบั๊ก
*   **Phase 7: บิวด์โปรเจกต์และรันเทสรวม** — ตรวจหาคีย์หลุด/ช่องโหว่ความปลอดภัยด้วย `devsecops-engineer` (**Gate 3**) และกรองเทสที่สถาปนาขึ้นมาหลอกๆ ด้วย `test-quality-auditor` (**Gate 4**)
*   **Phase 8: เตรียมการ Release & Deployment** — เตรียมรันสคริปต์ไมเกรชันฐานข้อมูลและแผน Rollback หากเป็นงานอันตรายจะหยุดขอรับความยินยอมที่ **Gate C (Human Release Approval)**
*   **Phase 9: ส่งมอบคู่มือและการทำงาน** — จัดทำ Runbook สำหรับผู้ดำเนินงาน และส่งมอบความรู้กลับสู่สารบัญระบบ
</details>

---

## 🤖 อธิบายแต่ละ Agents คือใคร ใช้ทำงานอะไร? (Who are the Agents & What do they do?)

ทีมงาน AI ประจำโปรเจกต์นี้ได้รับการดีไซน์มาในรูปแบบ **Specialist Guild (กิลด์ผู้ชำนาญการเฉพาะด้าน)** ประกอบด้วยเอเจนท์ 10 ตัวที่มีบทบาท หน้าที่ เกทความยินยอม และสิทธิ์การเข้าถึงไฟล์ต่างกันอย่างชัดเจน:

| โลโก้ / ชื่อ | ประเภทสิทธิ์ (Access) | หน้าที่หลักและขั้นตอนที่เกี่ยวข้อง | เกทการอนุมัติ (Gate Check) |
|---|---|---|---|
| **`aidlc-lead`**<br>*(เวิร์กโฟลว์ออร์เคสเตรเตอร์)* | 📝 **Write / Edit** | ขับเคลื่อน SDLC ตั้งแต่เฟสแรกจนจบ, วิเคราะห์ Requirements, เขียนสเปก และเขียน Implementation Plan รวมถึงสั่งสั่งการ Sub-agents | **ผู้รันกระบวนการหลัก** |
| **`team-leader`**<br>*(ผู้สังเกตการณ์ออร์เคสเตรเตอร์)* | 👁️ **Read-Only** | ตรวจสอบ codebase, วางโครงสร้างแผนงานกว้างๆ, ประเมินความเสี่ยง และสั่งงาน specialist แต่ **จะไม่เขียนหรือแก้ไขโค้ดใดๆ** เพื่อป้องกันการเสียหาย | **ผู้นำตรวจตราภาพรวม** |
| **`plan-reviewer`**<br>*(ผู้ตรวจสอบแผนพัฒนา)* | 👁️ **Read-Only** | ตรวจสอบคุณภาพแผนงาน (Implementation Plan) ใน Phase 4 หาจุดขัดแย้ง ความเป็นไปได้ และ traceability ก่อนลงมือเขียนโค้ด | **Gate 1 (Plan Review)** |
| **`researcher`**<br>*(นักวิจัยความจริง)* | 👁️ **Read-Only** | สำรวจ codebase, อ่าน API, แผนผัง, ค้นหาจุดเชื่อมต่อ (Integration Points) เพื่อให้ข้อมูลที่ประหยัดโทเคนและรวดเร็วใน Phase 1 | **สแกนเนอร์บริบท** |
| **`security-auditor`**<br>*(ผู้พิทักษ์ความปลอดภัย)* | 👁️ **Read-Only** | ตรวจสอบความปลอดภัยของโค้ดใน Phase 5 เฉพาะจุดที่แตะต้อง Authentication, Secret management, บัญชีเครือข่าย หรือกระบวนการสำคัญ | **Gate 2 (Security Architecture)** |
| **`devsecops-engineer`**<br>*(วิศวกรความปลอดภัย CI/CD)* | 👁️ **Read-Only** | รันกระบวนการตรวจสอบคุณภาพแบบรวม เช่น ตรวจหา CVE, ความถูกต้องของ static types (เช่น `tsc`), ลบช่องโหว่ และตรวจโทเคนหลุดรั่วใน Phase 7 | **Gate 3 (Build & Secret Leaks)** |
| **`test-quality-auditor`**<br>*(ผู้ตรวจจับเทสลวง)* | 👁️ **Read-Only** | วิเคราะห์ชุดทดสอบที่ถูกเขียนขึ้นใน Phase 7 ป้องกันการเขียน **"เทสลวง"** (เช่น `expect(true).toBe(true)` หรือการยัด mock หลอกเพื่อข้ามเกท) | **Gate 4 (Test Completeness)** |
| **`fullstack-engineer`**<br>*(วิศวกรแอปพลิเคชัน)* | 📝 **Write / Edit** | พัฒนาสถาปัตยกรรมฝั่งหน้าบ้าน (UI Component), เขียน Business Logic, API Controllers, และการทำงานฝั่งแอปพลิเคชันทั่วไปใน Phase 5 | **ทีมงานปฏิบัติการ** |
| **`platform-engineer`**<br>*(วิศวกรโครงสร้างพื้นฐาน)* | 📝 **Write / Edit** | พัฒนาและเขียนสคริปต์ Docker, จัดการฐานข้อมูล, แก้ไข SQL Migration, ปรับการตั้งค่า CI/CD pipeline และ Network ใน Phase 5 | **ทีมงานปฏิบัติการ** |
| **`test-engineer`**<br>*(วิศวกรผู้สร้างชุดทดสอบ)* | 📝 **Write / Edit** | ออกแบบโครงสร้างและเขียน Unit Tests, Integration Tests, และ End-to-End Tests เพื่อปกป้องระบบจากข้อผิดพลาดใน Phase 5 | **ทีมงานปฏิบัติการ** |

---

## 🧠 อธิบายแต่ละ Skills คืออะไร ใช้ทำงานอะไร? (What are the Skills & What do they do?)

> 📖 **[คลิกเพื่ออ่านสารบัญอธิบายความสามารถย่อยทั้ง 64 ตัวโดยละเอียด (docs/SKILLS_DICTIONARY.md)](./docs/SKILLS_DICTIONARY.md)**
> *เราได้รวบรวมคำอธิบายภาษาไทยสำหรับทุกความสามารถย่อยของ 9arm, Matt Pocock, Andrej Karpathy, Loop Engineering และ Superpowers ครบทุกตัวไว้ที่นี่แล้ว*

ความสามารถเฉพาะทาง **64 Skills** ทั้งหมดได้รับการจัดกลุ่มตามคอลเลกชันเพื่อสถาปนาความชาญฉลาดรอบด้านให้เอเจนท์ และผู้ใช้สามารถหยิบใช้ได้ผ่าน CLI:

### 🌟 1. `9arm-skills` (กลุ่มทักษะความรัดกุมสไตล์พี่เก้า)
มุ่งเน้นการสร้างวินัยในการทำงาน การวิเคราะห์หาสาเหตุ และการป้องกันความล้มเหลว:
- **`debug-mantra`** (มนตราดีบั๊ก): ท่องสเต็ปการหยุดคิด วิเคราะห์ข้อมูลจากข้อเท็จจริง ห้ามเดาสุ่มเดาโค้ดเป็นอันขาดเมื่อเทสพัง
- **`post-mortem`** (วิเคราะห์ความผิดพลาดเชิงลึก): สรุปวิเคราะห์ root cause อย่างเป็นระบบเมื่อเกิดปัญหาร้ายแรงเพื่อทำเป็น runbook ป้องกันไม่ให้เกิดซ้ำอีก
- **`scrutinize`** (การเพ่งเล็งโค้ดอย่างเข้มงวด): คำสั่งสแกนโค้ดทุกบรรทัด มองหา edge cases และข้อจำกัดที่หลบซ่อนอยู่

### 💻 2. `mattpocock-skills` (กลุ่มวิศวกรรม TypeScript และโดเมน)
มุ่งสร้างมาตรฐานสถาปัตยกรรมซอฟต์แวร์ระดับสากล และความปลอดภัยของประเภทตัวแปร:
- **`tdd`** (กระบวนการขับเคลื่อนด้วยการทดสอบ): วนลูปตามหลักการสากล: เขียนเทสให้พัง (Red) $\rightarrow$ เขียนโค้ดให้ผ่าน (Green) $\rightarrow$ ปรับแต่งโค้ดให้สะอาด (Refactor)
- **`domain-modeling`** (การออกแบบโดเมนหลัก): ออกแบบ Entity, Value Object, และสถาปัตยกรรมตามหลัก DDD (Domain-Driven Design) เพื่อลดความสับสนของโค้ด
- **`code-review`** (วิจารณ์และพัฒนาร่วม): รีวิวโค้ดโดยอ้างอิงสเปกและความสอดคล้อง ปรับปรุงคุณภาพงานก่อนเข้าสู่กระบวนการเมิร์จจริง

### 🛡️ 3. `andrej-karpathy-guidelines` (4 กฎเหล็กสยบข้อผิดพลาด AI)
กฎแห่งความจริง (Empirical Grounding) เพื่อควบคุมพฤติกรรม LLM ไม่ให้หลุดลอยจากความถูกต้อง:
- บังคับให้ AI **รันคำสั่งตรวจสอบจริงเสมอ** (เช่น บิวด์, ทดสอบ, อ่านไฟล์จริง) ห้ามเดาหรือประเมินเอาเอง
- บังคับให้อ่านไฟล์ทีละส่วนอย่างรอบคอบเพื่อจำกัด Token และหลีกเลี่ยงการหลงลืมบริบท (Context Drift)

> ตัวติดตั้งจะ merge เนื้อหานี้เข้าไปในไฟล์ steering หลักของทุก CLI โดยอัตโนมัติ (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`, `~/.kiro/steering/ai-team-karpathy-guidelines.md`) ทำให้กฎเหล็กนี้ทำงานแบบ Always-On โดยไม่ต้องเรียก skill เอง

### ⛓️ 4. `loop-engineering` (กลุ่มทักษะสกัดกั้น AI ทำงานลูปอนันต์)
ควบคุมวินัยการใช้ทรัพยากร พลังงาน และงบประมาณ API ของคุณ:
- **`loop-budget`** (งบประมาณลูปแชท): ตั้งค่าขีดจำกัดอย่างเคร่งครัดว่า AI จะรันงานได้สูงสุดกี่รอบ และใช้ Token ไปเท่าใด หากเกินเกณฑ์จะทำการสั่งหยุดการรันทันที
- **`loop-verifier`** (ผู้ตรวจสอบลูปวนซ้ำ): ตรวจจับว่า AI มีพฤติกรรม "พยายามแก้บั๊กจุดเดิมด้วยวิธีเดิมๆ ซ้ำซ้อน" หรือไม่ หากตรวจพบจะบังคับเด้งแชทถามมนุษย์ให้ช่วยเคลียร์ทางทันที

### ⚡ 5. `superpowers` (กลุ่มยกระดับขีดความสามารถการพัฒนา)
ระบบอัตโนมัติในการวางแผนโครงงานและการควบคุมระบบจัดการโค้ด:
- **`writing-plans`** (การวาดแผนงาน): เขียนแผนปฏิบัติการเชิงลึกที่แตกย่อยชัดเจน (Granular Task List) พร้อมระบบ Traceability Matrix เชื่อมโยงทุก Requirements เข้ากับฟังก์ชันโค้ดจริง
- **`systematic-debugging`** (ระบบดีบั๊กเชิงวิเคราะห์): ไล่ตรวจสอบข้อผิดพลาดตั้งแต่ทฤษฎีต้นตอ, วิธีตรวจสอบ, และการเก็บหลักฐานยืนยันความถูกต้องหลังการแก้สำเร็จ
- **`using-git-worktrees`** (การจัดสาขางานรวดเร็ว): ใช้ความสามารถของ Git Worktree ในการสร้างโฟลเดอร์แยกตามกิ่งงาน ช่วยให้ AI และผู้ใช้สามารถสลับทำงานขนานกันได้อย่างสมบูรณ์

---

## 🛠️ ใช้งานอย่างไร? (How to use)

เมื่อคุณติดตั้งความสามารถ (Skills) และเอเจนท์เสร็จสิ้น คุณจะสามารถขับเคลื่อน SDLC อัตโนมัติด้วยคำสั่งสั้นๆ เพียงคำสั่งเดียวบน AI CLI:

### 🚀 ตัวอย่างการรันเวิร์กโฟลว์ด้วย `/aidlc`
เปิดโปรแกรมแชทของ CLI (เช่น Kiro CLI หรือ Claude Code) แล้วสั่งงาน:

```bash
# พิมพ์คำสั่งเริ่มเวิร์กโฟลว์อัตโนมัติ
kiro-cli chat
> /aidlc build the CSV export feature
```

หรือระบุโมเดลเฉพาะในการรันระบบ:
```bash
# สตาร์ท Claude Code โดยระบุผู้ประสานงานหลักเป็นผู้นำเวิร์กโฟลว์
claude --agent aidlc-lead
```

---

## 💾 วิธีติดตั้งของแต่ละ AI (How to install each AI CLI)

เราได้เตรียมสคริปต์ติดตั้งอัจฉริยะ **`install/install.sh`** ซึ่งจะสแกนหา AI CLI ทั้งหมดที่มีในเครื่องของคุณและรันขั้นตอน Setup ให้อัตโนมัติทันที:

```bash
# 1. โคลนและสลับไปยังโปรเจกต์นี้
git clone <this-repo-url> ~/pasitc-ai-agents-skills
cd ~/pasitc-ai-agents-skills

# 2. ตรวจสอบ CLI ในเครื่อง
./install/install.sh --list

# 3. ติดตั้งทั้งหมดโดยสมบูรณ์
./install/install.sh
```

---

### 💻 เลือกติดตั้งทีละแพลตฟอร์มแบบแมนนวล (Manual Setup)

<details>
<summary><b>🟢 1. Kiro CLI Setup (Verified v2.13.0)</b></summary>
<br>

Kiro CLI ใช้ไฟล์สเปกเอเจนท์ในรูปแบบ JSON คลาสสิก:
```bash
# รันตัวติดตั้ง Kiro แบบเจาะจงพร้อมเซ็ตเอเจนท์หลัก
./install/install-kiro.sh --set-default-agent

# ตรวจสอบการจัดเก็บไฟล์แมนนวล:
# - เอเจนท์: วางที่ ~/.kiro/agents/ (เช่น aidlc-lead.json, team-leader.json)
# - สัญญานำทาง (Steering): เก็บที่ ~/.kiro/steering/ai-team-global-rule.md
# - กฎเหล็ก Karpathy (Always-On): เก็บแยกที่ ~/.kiro/steering/ai-team-karpathy-guidelines.md
# - ความสามารถ (Skills): วางแบบแบนราบ (flat) ใน ~/.kiro/skills/
```
</details>

<details>
<summary><b>🟠 2. Claude Code Setup (Verified v2.1.216)</b></summary>
<br>

Claude Code ใช้ไฟล์ Markdown สำหรับการมอบหมายหน้าที่และพฤติกรรมความสามารถ:
```bash
# รันตัวติดตั้ง Claude Code ผูกกับโปรเจกต์เป้าหมายของคุณ
./install/install-claude.sh --project ~/code/my-app --set-default-agent

# หรือเขียนตั้งค่าเอเจนท์ประเจกต์เป้าหมายผ่าน ~/.claude/settings.json
{ "agent": "team-leader" }

# การจัดเก็บไฟล์:
# - เอเจนท์ระบบ: ~/.claude/agents/
# - เอเจนท์ในโปรเจกต์: <project>/.claude/agents/
# - Steering Rule + กฎเหล็ก Karpathy (Always-On): เสียบเชื่อมที่ท้ายไฟล์ CLAUDE.md ของโปรเจกต์เป้าหมาย
```
</details>

<details>
<summary><b>🔵 3. Codex CLI Setup (Verified v0.144.6)</b></summary>
<br>

Codex ใช้ไฟล์ TOML สำหรับควบคุม Specialist Agents และยึดกติการ่วมผ่าน `AGENTS.md`:
```bash
# รันตัวติดตั้งเอเจนท์ Codex
./install/install-codex.sh --install-agents

# การจัดเก็บไฟล์:
# - เอเจนท์ TOML: ~/.codex/agents/ (ประมวลจาก Markdown ฝั่ง Claude ต้นทาง)
# - ทักษะผู้ใช้ (Skills): วางที่ ~/.agents/skills/ (ไม่ใช่ ~/.codex/skills)
# - Steering + กฎเหล็ก Karpathy (Always-On): ต่อท้ายใน ~/.codex/AGENTS.md
```
</details>

<details>
<summary><b>🟣 4. Gemini CLI Setup (Verified v0.51.0)</b></summary>
<br>

Gemini และ Antigravity ขับเคลื่อนด้วยไฟล์อ้างอิง Markdown:
```bash
# รันตัวติดตั้งฝั่ง Gemini
./install/install-gemini.sh --install-agents

# การจัดเก็บไฟล์:
# - เอเจนท์ความรู้: ~/.gemini/agents/ (เรียกใช้งานผ่าน @<name> ในแชท)
# - ทักษะผู้ใช้: ~/.gemini/skills/
# - Steering + กฎเหล็ก Karpathy (Always-On): บันทึกเชื่อมต่อท้าย ~/.gemini/GEMINI.md
```
</details>

---

## 📦 การติดตั้งเครื่องมือเสริมระดับองค์กร (External/Vendor Bundles)

เพื่อความมั่นใจในการทำงานแบบ **Offline 100%** เราได้คัดลอกไฟล์ซอร์สโค้ดเต็มของโปรเจกต์สหายเวิร์กสเปซเข้ามาบรรจุไว้ในโฟลเดอร์ [`vendor/`](./vendor) เรียบร้อยแล้ว คุณสามารถสั่งติดตั้งสู่ระบบได้โดยตรงโดยไม่ต้องอาศัยการดาวน์โหลดจากอินเทอร์เน็ต:

```bash
# 1. ติดตั้ง Superpowers, Ponytail, Obsidian Second Brain เข้าสู่ทุกระบบที่ตรวจพบ in เครื่อง
./install/install-external.sh

# 2. ติดตั้ง CodeGraph และ Graphify (สคริปต์นี้ต้องใช้เน็ตเพื่อคอมไพล์ binary เฉพาะ OS)
./install/install-compiled-tools.sh
```

---

## 📁 โครงสร้างโปรเจกต์ (Repository File Map)

```
pasitc-ai-agents-skills/
├── agents/                      # 🤖 ชุดทำเนียบ AI เอเจนท์ 10 ตัวแบ่งตามระบบ
│   ├── project-agents/          # สเปก Markdown สำหรับในโครงการ (Claude Code)
│   ├── user-agents/             # สเปก Markdown ทั่วไปในระบบผู้ใช้
│   ├── kiro-agents/             # เอเจนท์รูปแบบ JSON คลาสสิก (Kiro CLI)
│   ├── codex-agents/            # เอเจนท์ TOML ที่สร้างอัตโนมัติ (Codex CLI)
│   └── gemini-agents/           # เอเจนท์ Markdown เฉพาะตัว (Gemini)
├── skills/                      # 🧠 ความสามารถ 64 ตัวแยกหมวดหมู่เป็นโฟลเดอร์ flat
│   ├── 9arm-skills/             # กลุ่มทักษะเพื่อการดีบั๊กและตรวจสอบจากชุมชนไทย
│   ├── mattpocock-skills/       # ทักษะเขียนโค้ด TypeScript คุณภาพสูงระดับโปร
│   ├── andrej-karpathy-guidelines/# 4 กฎเหล็กควบคุมความประพฤติและตรรกะของ AI
│   ├── loop-engineering/        # ทักษะสกัดกั้นลูป AI วิ่งวนและพองราคาโทเคน
│   └── superpowers/             # ทักษะอัตโนมัติเชิงลึก วางแผน และคุมสาขา Git
├── docs/                        # 📚 เอกสารนโยบายกลางและเวิร์กโฟลว์มาตรฐาน
│   ├── GLOBAL_RULE.md           # กฎความประพฤติสากลที่เชื่อมต่อทุกเอเจนท์ในทุก CLI
│   ├── WORKFLOW.md              # คู่มือวิเคราะห์เวิร์กโฟลว์ AIDLC-lite 10 ขั้นตอน
│   ├── TEAM_LEADER.md           # คู่มือควบคุมสิทธิ์การทำงานของทีมลีดเดอร์
│   └── templates/               # แม่แบบสรุปบันทึกการทำงาน SDLC รายสัปดาห์/ฟีเจอร์
├── install/                     # ⚙️ สคริปต์เชลล์ติดตั้งอัจฉริยะแบบแยกแพลตฟอร์ม
│   ├── install.sh               # ศูนย์กลางตรวจสอบและกระจายงานติดตั้งทั้งหมด
│   ├── install-external.sh      # ตัวลงโมเดลเสริมจากโฟลเดอร์ Vendor โลคอล
│   └── generate-agents.py       # เอนจิ้นแปลง Markdown source-of-truth เป็น JSON/TOML
└── vendor/                      # 📦 แพ็คเกจเสริมฉบับเต็มเพื่อติดตั้งโลคอล
    ├── superpowers/             # obra/superpowers ตัวเต็ม
    ├── ponytail/                # DietrichGebert/ponytail ตัวเต็ม
    └── obsidian-second-brain/   # eugeniughelbur/obsidian-second-brain
```

---

## 📜 การให้เครดิตและสัญญาอนุญาต (Credits & License)

เรารักษาความสุจริตและให้เกียรติผู้สร้างสรรค์ต้นทางอย่างสูงสุด ความสามารถและโค้ดเสริมทั้งหมดในโปรเจกต์ได้รับการระบุสิทธิ์และสัญญาอนุญาตต้นทางไว้อย่างชัดเจนในไฟล์ [**`CREDITS.md`**](./CREDITS.md) 

| ชุดทักษะ (Skill Collection) | แหล่งอ้างอิงต้นทาง (Original Source) | สัญญาอนุญาต (License) |
|---|---|---|
| `9arm-skills` | [thananon/9arm-skills](https://github.com/thananon/9arm-skills) | ตรวจสอบที่ต้นทาง |
| `mattpocock-skills` | [mattpocock/skills](https://github.com/mattpocock/skills) | MIT License |
| `andrej-karpathy-guidelines` | [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) | MIT License |
| `loop-engineering` | [cobusgreyling/loop-engineering](https://github.com/cobusgreyling/loop-engineering) | MIT License |
| `superpowers` | [obra/superpowers](https://github.com/obra/superpowers) | MIT License |

ซอร์สสคริปต์สถาปัตยกรรม, เอกสารคู่มือ, และเครื่องมือสร้างแปลงไฟล์ (Generator) ที่พัฒนาเพิ่มเติมโดย **pasitc** สงวนสิทธิ์ภายใต้สัญญาอนุญาตแบบ **MIT License** ดูรายละเอียดเพิ่มเติมที่ไฟล์ [**`LICENSE`**](./LICENSE) 

---
<div align="center">
<b>🚀 พัฒนาซอฟต์แวร์ด้วยความรัก ความรัดกุม และตรรกะอันเฉียบคมร่วมกับ AI ในฝันของคุณในวันนี้นะครับ!</b>
</div>