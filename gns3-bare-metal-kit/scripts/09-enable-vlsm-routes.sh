#!/usr/bin/env bash
#==============================================================================
# Project:     GNS3 Bare-Metal Server Kit (Ubuntu 24.04)
# Script:      09-enable-vlsm-routes.sh
# Version:     1.0.0
# Author:      Davis Boudreau
# License:     MIT
# SPDX-License-Identifier: MIT
#
# Summary:
#   - Installs and enables a persistent host routing policy for VLSM lab subnets
#   - Routes are sent to the "project router" at 192.168.100.2 on virbr0
#
# Routed subnets:
#   - 192.168.100.64/27
#   - 192.168.100.96/27
#   - 192.168.100.128/27
#   - 192.168.100.160/27
#   - 192.168.100.192/27
#   - 192.168.100.224/27
#
# IMPORTANT:
#   - These routes are always present on the host.
#   - They only "work" when a GNS3 project router is configured at 192.168.100.2
#     and is routing those subnets.
#
# Usage:
#   sudo bash scripts/09-enable-vlsm-routes.sh
#   sudo bash scripts/09-enable-vlsm-routes.sh --dry-run
#==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

parse_common_flags "$@"

need_root
init_logging
setup_traps
require_real_run

require_cmd systemctl
require_cmd ip

SRC="${SCRIPT_DIR}/../systemd/gns3-vlsm-routes.service"
DST="/etc/systemd/system/gns3-vlsm-routes.service"

report_add "Script" "$(basename "$0")"
report_add "Service installed" "gns3-vlsm-routes.service"
report_add "Next hop" "192.168.100.2 via virbr0"
report_add "Reboot required" "NO"

echo "=============================="
echo " Enable VLSM Host Routes (permanent)"
echo " Next-hop (project router): 192.168.100.2"
echo " Device: virbr0"
echo "=============================="

[[ -f "${SRC}" ]] || die "Missing unit template: ${SRC}"

echo "[1/4] Installing systemd unit..."
run cp -a "${SRC}" "${DST}"
run chmod 644 "${DST}"

echo "[2/4] Enabling and starting service..."
run systemctl daemon-reload
run systemctl enable --now gns3-vlsm-routes.service

echo "[3/4] Service status..."
systemctl status gns3-vlsm-routes.service --no-pager || true

echo "[4/4] Applied routes:"
ip route | grep -E '^192\.168\.100\.(64|96|128|160|192|224)/27' || true

echo ""
echo "Done."
echo "Tip: When a GNS3 project router uses 192.168.100.2 on virbr0, these subnets can be routed behind it."
echo ""
