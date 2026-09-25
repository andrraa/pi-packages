#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
git pull --ff-only
node -e '
const fs = require("fs");
const p = process.env.HOME + "/.pi/agent/settings.json";
const s = JSON.parse(fs.readFileSync(p, "utf8"));
s.packages = JSON.parse(fs.readFileSync("packages.json", "utf8"));
fs.writeFileSync(p, JSON.stringify(s, null, 2) + "\n");
'
pi update --extensions
pi list
