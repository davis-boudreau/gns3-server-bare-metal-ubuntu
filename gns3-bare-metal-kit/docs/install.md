# Install Guide (Ubuntu 24.04)

> **Run steps 01 and 04 from a local console if possible.**  
> Netplan changes can momentarily interrupt networking and drop SSH.

## Prereqs

- Ubuntu Server 24.04 LTS installed
- You have console access (recommended)
- You know the IP settings for your lab network

## Execution Order (Do Not Deviate)

| Step | Script                                   | Must Run As        | Reboot After |
|------|------------------------------------------|--------------------|--------------|
| 01   | `scripts/01-prepare-gns3-host.sh`         | `root`             | ✅ YES        |
| 02   | `scripts/02-install-docker.sh`            | `root`             | ✅ YES        |
| 03   | `scripts/03-install-gns3-server.sh`       | `root`             | ✅ YES        |
| 04   | `scripts/04-bridge-tap-provision.sh`      | `root`             | ✅ YES        |
| 05   | `scripts/05-expand-root-lvm-ubuntu.sh`    | `root` (Ubuntu LVM)| —            |
| 06   | `scripts/08-configure-libvirt-default-nat.sh` | `root`        | —            |
| 07   | `scripts/09-enable-vlsm-routes.sh`        | `root`             | —            |
| 08   | `scripts/07-verify-host.sh`               | `root`             | —            |
| 09   | Connect from GNS3 GUI                     | logged-in user     | —            |

> **Why this order matters:**  
> The bridge + TAP layer must be built **after** Docker + GNS3 to avoid cloud-node failures and permission issues.

---

## Step 01 — Prepare Host

```bash
sudo bash scripts/01-prepare-gns3-host.sh
sudo reboot
```

What it does:
- Prompts for NIC + static IPv4 and writes Netplan (`/etc/netplan/01-static-ip.yaml`)
- Sets timezone and enables NTP
- Installs admin/network utilities
- Installs and enables OpenSSH server
- Creates `gns3` user (optional passwordless sudo)
- Installs KVM/libvirt baseline + kernel/sysctl tuning

---

## Step 02 — Install Docker CE

```bash
sudo bash scripts/02-install-docker.sh
sudo reboot
```

What it does:
- Installs Docker CE from official Docker repo
- Enables Docker
- Adds `gns3` user to `docker` group

---

## Step 03 — Install GNS3 Server (Ubuntu PPA)

```bash
sudo bash scripts/03-install-gns3-server.sh
sudo reboot
```

What it does:
- Installs GNS3 Server + ubridge + KVM/libvirt dependencies
- Writes `gns3_server.conf` with explicit tool paths
- Installs and enables `gns3server` systemd service
- Verifies `ubridge` is executable for the `gns3` user

---

## Step 04 — Bridge + TAP Provision

```bash
sudo bash scripts/04-bridge-tap-provision.sh
sudo reboot
```

What it does:
- Creates Netplan bridge config (`br0` owns the IP; NIC becomes bridge port)
- Installs and enables `gns3-taps.service` so TAPs persist after reboot

---

## Step 05 — Expand Root Filesystem (Ubuntu default LVM only)

If your Ubuntu install used the default LVM layout and you have free space in the volume group, expand the root filesystem:

```bash
sudo bash scripts/05-expand-root-lvm-ubuntu.sh
```

This step is safe to run multiple times. If the default LV does not exist, it exits without changing anything.

---

## Step 06 — Configure libvirt NAT network (virbr0) to /26 + fixed DHCP

This pre-provisions the libvirt **default** NAT network (virbr0) for predictable student labs:

- Gateway: `192.168.100.1/26`
- DHCP: `192.168.100.33` → `192.168.100.62`

```bash
sudo bash scripts/08-configure-libvirt-default-nat.sh
```

---

## Step 07 — Enable permanent VLSM routes (host policy)

This installs a systemd oneshot service that permanently installs host routes for VLSM subnets via the **project router** at `192.168.100.2`:

- `192.168.100.64/27`
- `192.168.100.96/27`
- `192.168.100.128/27`
- `192.168.100.160/27`
- `192.168.100.192/27`
- `192.168.100.224/27`

```bash
sudo bash scripts/09-enable-vlsm-routes.sh
```

> These routes only become useful when a GNS3 project router is configured at `192.168.100.2` and is routing those subnets.

---

## Step 08 — Verify host readiness

After Step 04 (and reboot), run:

```bash
sudo bash scripts/07-verify-host.sh
```

This performs non-mutating checks for:
- KVM
- Docker
- gns3server
- br0 + tap0/tap1 + gns3-taps service
- libvirt default NAT network settings (virbr0)
- permanent VLSM routes via `192.168.100.2`

Exit code `0` means READY.

---

## Step 09 — Connect from GNS3 GUI

- Add remote server: the host’s IP
- Add a Cloud node and bind to `tap0` / `tap1`

---

## Logging

All scripts write logs to:

- `/var/log/gns3-bare-metal/`

Each script run creates a timestamped log file.

To package logs for support/submission:

```bash
sudo bash scripts/06-collect-logs.sh
```

---

## Dry-run (advanced)

Preview what each script will do:

```bash
sudo bash scripts/02-install-docker.sh --dry-run
```

---

## References

- Docker Engine install (Ubuntu): https://docs.docker.com/engine/install/ubuntu/
- Docker Engine install (Debian): https://docs.docker.com/engine/install/debian/
- GNS3 Linux install: https://docs.gns3.com/docs/getting-started/installation/linux/
