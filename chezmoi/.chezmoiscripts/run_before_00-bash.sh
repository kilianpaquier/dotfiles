#!/bin/sh

set -e

umask 022

if ! command -v bash >/dev/null 2>&1; then
  sudo apt update
  sudo apt -y install bash
fi
