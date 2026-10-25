#!/bin/zsh
set -euo pipefail
cd "${0:A:h}/.."
work=$(mktemp -d /tmp/sip-model.XXXXXX)
trap 'rm -rf "$work"' EXIT
swiftc SipAndSee/Drink.swift scripts/model-checks.swift -o "$work/checks"
"$work/checks"
