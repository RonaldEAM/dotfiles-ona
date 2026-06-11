# Design: Claude Code Plugin Setup for Ona Environments

**Date:** 2026-05-14

## Overview

Add automated Claude Code plugin installation to the dotfiles-ona setup, so that any new Ona environment gets superpowers, caveman, and humanizer installed as part of the standard `install.sh` run.

## Assumptions

- `claude` CLI is already installed before `install.sh` runs.
- `git` is available (already required by existing setup).

## Files

### New: `claude/claude.sh`

A standalone shell script executed (not sourced) during install. Handles all three plugin installations idempotently.

### Modified: `install.sh`

Adds a section at the end that calls:

```bash
bash "$DOTFILES_DIR/claude/claude.sh"
```

## `claude/claude.sh` — Step-by-Step Logic

### 1. superpowers

```
if not already installed:
  claude plugin install superpowers@claude-plugins-official
```

Idempotency check: `claude plugin list` output is inspected for `superpowers`.

### 2. caveman

```
if caveman marketplace not registered:
  claude plugin marketplace add JuliusBrussee/caveman

if not already installed:
  claude plugin install caveman@caveman
```

Idempotency check: `claude plugin marketplace list` for marketplace; `claude plugin list` for plugin.

### 3. humanizer

```
if ~/.claude/skills/humanizer does not exist:
  git clone https://github.com/blader/humanizer.git ~/.claude/skills/humanizer
else:
  git -C ~/.claude/skills/humanizer pull
```

Humanizer is a skill (not a plugin), so it's installed by cloning into `~/.claude/skills/`. Existing clones are kept up to date with a `git pull`.

## Output Style

Each step prints `==> ...` status lines matching the existing `install.sh` convention.

## Error Handling

Uses `set -euo pipefail` so any failure exits immediately. The caller (`install.sh`) already uses the same flag, so failures surface clearly.
