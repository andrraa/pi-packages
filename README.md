# pi-packages

Single source of truth for the [Pi](https://pi.dev) package list, shared across machines (daily-driver Mac and work laptop).

Pi keeps installed packages in `~/.pi/agent/npm/`, but the authoritative list lives in the `packages` key of `~/.pi/agent/settings.json`. That file also holds per-machine settings (default model, theme, etc.), so this repository tracks only the package list and applies it declaratively.

## How it works

```
packages.json   # the package list (this repo is the source of truth)
sync.sh         # pulls, applies the list to settings.json, reconciles installs
```

`sync.sh` performs:

1. `git pull --ff-only`
2. Overwrite the `packages` key in `~/.pi/agent/settings.json` (all other keys untouched)
3. `pi update --extensions` — installs anything declared but missing
4. `pi list` — prints the resulting configuration

Installed package code does not need to be synced; `pi update --extensions` reconstructs it from the declared list.

## Setup (once per machine)

```bash
git clone git@github.com:andrraa/pi-packages.git
./sync.sh
```

## Usage

- **Add or remove a package:** edit `packages.json`, commit, and push. On the other machine, run `./sync.sh`.
- Do **not** use `pi install` / `pi remove` directly on synced machines — local edits are overwritten on the next sync. All changes go through `packages.json`.
- Everything else (default provider/model, theme, skills, memory, credentials) remains local to each machine and is intentionally not synced.

## Notes

- Unversioned specs (e.g. `npm:pi-memory`) always resolve to the latest version on reconcile. Pin explicitly (e.g. `npm:pi-memory@1.2.3`) for reproducibility.
- Removing a package from the list stops it from loading after sync. Stale install directories under `~/.pi/agent/npm/` are inert; clean them up with `pi remove` at any time.
- The list is identical on every machine. Per-machine package differences are not supported by design (the sync is overwrite-based).
