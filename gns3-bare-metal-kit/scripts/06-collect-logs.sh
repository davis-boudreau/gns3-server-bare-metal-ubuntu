#!/usr/bin/env bash
#==============================================================================
# Project:     GNS3 Bare-Metal Server Kit (Ubuntu 24.04)
# Script:      06-collect-logs.sh
# Version:     1.0.0
# Author:      Davis Boudreau
# Email:       davis.boudreau@nscc.ca
# License:     MIT
# SPDX-License-Identifier: MIT
#
# Summary:
#   - Collect logs for support / student submissions
# ==============================================================================
set -euo pipefail

LOG_DIR="${LOG_DIR:-/var/log/gns3-bare-metal}"
OUT="${1:-gns3-bare-metal-logs-$(date +%Y-%m-%d_%H-%M-%S).tar.gz}"

if [[ ! -d "${LOG_DIR}" ]]; then
  echo "Log directory not found: ${LOG_DIR}"
  exit 1
fi

echo "Collecting logs from: ${LOG_DIR}"
tar -czf "${OUT}" -C "${LOG_DIR}" .
echo "Created: ${OUT}"
