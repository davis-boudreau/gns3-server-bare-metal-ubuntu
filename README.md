# GNS3 Bare-Metal Server Kit

**Ubuntu 24.04 LTS**

A structured, reproducible **bare-metal deployment framework** for building a fully functional GNS3 Server host on Ubuntu 24.04.

This repository is designed as an **infrastructure runbook**, not a collection of ad-hoc scripts.

---

## 🚀 What This Project Does

This kit installs and configures a complete GNS3 server environment including:

* Static IPv4 networking (Netplan)
* KVM / libvirt virtualization baseline
* Docker Engine (official repository)
* GNS3 Server (Ubuntu PPA)
* Linux bridge (`br0`)
* Persistent TAP interfaces (`tap0`, `tap1`)
* Systemd-managed services
* Structured logging and verification

The end result is a **stable, repeatable, classroom-ready GNS3 bare-metal host**.

---

## 🎯 Intended Audience

This project is intended for:

* networking and cybersecurity students
* instructors deploying lab infrastructure
* administrators building reusable teaching platforms
* offline or USB-based deployments
* environments requiring repeatability and auditability

The scripts are intentionally verbose and instructional.

---

## 🧩 Supported Platform

| Component      | Support                 |
| -------------- | ----------------------- |
| OS             | Ubuntu Server 24.04 LTS |
| Deployment     | Bare metal              |
| Virtualization | KVM                     |
| GNS3 Mode      | Remote server           |
| Install Media  | USB or local copy       |

> ⚠️ Debian is **not currently supported** for GNS3 installation due to Ubuntu-specific PPA requirements.

---

## 📁 Repository Structure

```
gns3-bare-metal-kit/
├─ scripts/
│  ├─ 01-prepare-gns3-host.sh
│  ├─ 02-install-docker.sh
│  ├─ 03-install-gns3-server.sh
│  ├─ 04-bridge-tap-provision.sh
│  ├─ 05-expand-root-lvm-ubuntu.sh
│  ├─ 06-collect-logs.sh
│  ├─ 07-verify-host.sh
│  └─ lib/
│     └─ common.sh
│
├─ docs/
│  ├─ install.md
│  ├─ troubleshooting.md
│  └─ architecture.md
│
├─ CHANGELOG.md
├─ LICENSE
└─ README.md
```

---

## 🧭 Installation Overview

Installation follows a **strict, ordered workflow**.

The process begins with **Step 00**, where all files are copied from USB to the local filesystem to ensure availability across reboots.

> ❗ Scripts must **never** be executed directly from removable media.

The full, authoritative installation guide is located here:

👉 **[`docs/install.md`](docs/install.md)**

This guide covers:

* USB deployment workflow (Step 00)
* exact execution order
* reboot requirements
* storage expansion
* logging and dry-run mode
* host readiness verification

---

## 🧠 Installation Model

```
USB Media
   ↓
Local Home Directory (installer user)
   ↓
System Preparation (network, users, KVM)
   ↓
Docker Runtime
   ↓
GNS3 Server
   ↓
Linux Bridge (br0)
   ↓
TAP Interfaces (tap0 / tap1)
   ↓
Verified Host Readiness
```

---

## 📝 Logging

All scripts automatically log execution output.

**Log location:**

```
/var/log/gns3-bare-metal/
```

Each script execution creates a timestamped log file and mirrors output to the console.

A helper script is provided to package logs:

```bash
sudo bash scripts/06-collect-logs.sh
```

---

## 🧪 Dry-Run Mode (Advanced)

Every script supports a dry-run mode that prints intended actions without modifying the system.

Example:

```bash
sudo bash scripts/02-install-docker.sh --dry-run
```

Dry-run mode is useful for:

* reviewing changes before execution
* classroom demonstrations
* validation and troubleshooting

---

## ✅ Host Readiness Verification

After installation, system health can be validated using:

```bash
sudo bash scripts/07-verify-host.sh
```

This performs **non-mutating checks** including:

* KVM acceleration
* Docker service
* GNS3 server service
* ubridge permissions
* Linux bridge integrity
* TAP interface persistence

Exit codes:

| Code | Meaning   |
| ---- | --------- |
| `0`  | READY     |
| `1`  | NOT READY |

---

## 🧱 Design Philosophy

This project prioritizes:

* explicit execution order
* safe defaults
* idempotent operations where possible
* auditability through logging
* reproducibility across semesters
* clarity over cleverness

The goal is to behave like a **real infrastructure deployment runbook**.

---

## 📜 License

MIT License
Copyright © 2026 Davis Boudreau

---

## 🤝 Contributing

This project is intended primarily for instructional use.

Contributions are welcome if they:

* maintain clarity and structure
* preserve step ordering
* do not obscure learning objectives
* improve reliability or documentation

---

## ⭐ Final Note

This repository exists to make bare-metal GNS3 deployments:

* predictable
* teachable
* repeatable
* supportable
