#!/usr/bin/env bash
set -euo pipefail
# Builds Docker image and enters a terminal session inside the container.
# Allows AWSCLI and Terraform to be run consistently between users and scripts.

docker build -t spin-manager . && docker run -it --rm -v "/$(PWD)":/spin_manager:Z -w /spin_manager/cli -v "/$HOME/.aws":/root/.aws spin-manager sh
