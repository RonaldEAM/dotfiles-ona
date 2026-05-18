# Claude Code Plugin Setup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `claude/claude.sh` script that idempotently installs superpowers, caveman, and humanizer into Claude Code, and wire it into `install.sh`.

**Architecture:** A single executable shell script (`claude/claude.sh`) that `install.sh` calls directly. Each of the three plugins has its own idempotency check before installing. Superpowers and caveman use `claude plugin install`; humanizer is cloned into `~/.claude/skills/`.

**Tech Stack:** Bash, Claude Code CLI (`claude plugin`), git

---

### Task 1: Create `claude/claude.sh` skeleton

**Files:**
- Create: `claude/claude.sh`

- [ ] **Step 1: Create the file with set flags and a placeholder echo**

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "==> Setting up Claude Code plugins..."
echo "==> Done."
```

Save to `claude/claude.sh`.

- [ ] **Step 2: Make it executable and run it to verify it works**

```bash
chmod +x claude/claude.sh
bash claude/claude.sh
```

Expected output:
```
==> Setting up Claude Code plugins...
==> Done.
```

- [ ] **Step 3: Commit**

```bash
git add claude/claude.sh
git commit -m "feat: add claude/claude.sh skeleton"
```

---

### Task 2: Add superpowers install

**Files:**
- Modify: `claude/claude.sh`

- [ ] **Step 1: Add idempotent superpowers install block**

Replace the placeholder echo with:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "==> Setting up Claude Code plugins..."

# superpowers
if claude plugin list 2>/dev/null | grep -q "superpowers@"; then
  echo "==> superpowers already installed, skipping"
else
  echo "==> Installing superpowers..."
  claude plugin install superpowers@claude-plugins-official
fi

echo "==> Done."
```

- [ ] **Step 2: Run the script — verify idempotent path triggers (plugin already installed)**

```bash
bash claude/claude.sh
```

Expected output (since superpowers is already installed):
```
==> Setting up Claude Code plugins...
==> superpowers already installed, skipping
==> Done.
```

- [ ] **Step 3: Commit**

```bash
git add claude/claude.sh
git commit -m "feat: add superpowers install to claude.sh"
```

---

### Task 3: Add caveman install

**Files:**
- Modify: `claude/claude.sh`

- [ ] **Step 1: Add caveman marketplace registration and install block**

Insert after the superpowers block (before the final `echo "==> Done."`):

```bash
# caveman
if ! claude plugin marketplace list 2>/dev/null | grep -q "^\s*❯ caveman"; then
  echo "==> Registering caveman marketplace..."
  claude plugin marketplace add JuliusBrussee/caveman
fi

if claude plugin list 2>/dev/null | grep -q "caveman@caveman"; then
  echo "==> caveman already installed, skipping"
else
  echo "==> Installing caveman..."
  claude plugin install caveman@caveman
fi
```

- [ ] **Step 2: Run the script — verify idempotent path for caveman**

```bash
bash claude/claude.sh
```

Expected output:
```
==> Setting up Claude Code plugins...
==> superpowers already installed, skipping
==> caveman already installed, skipping
==> Done.
```

- [ ] **Step 3: Commit**

```bash
git add claude/claude.sh
git commit -m "feat: add caveman install to claude.sh"
```

---

### Task 4: Add humanizer skill install

**Files:**
- Modify: `claude/claude.sh`

- [ ] **Step 1: Add humanizer clone/pull block**

Insert after the caveman block (before the final `echo "==> Done."`):

```bash
# humanizer skill
HUMANIZER_DIR="${HOME}/.claude/skills/humanizer"
if [ -d "$HUMANIZER_DIR" ]; then
  echo "==> Updating humanizer skill..."
  git -C "$HUMANIZER_DIR" pull --ff-only
else
  echo "==> Installing humanizer skill..."
  mkdir -p "${HOME}/.claude/skills"
  git clone https://github.com/blader/humanizer.git "$HUMANIZER_DIR"
fi
```

- [ ] **Step 2: Run the script — verify humanizer update path triggers (already cloned)**

```bash
bash claude/claude.sh
```

Expected output:
```
==> Setting up Claude Code plugins...
==> superpowers already installed, skipping
==> caveman already installed, skipping
==> Updating humanizer skill...
Already up to date.
==> Done.
```

- [ ] **Step 3: Commit**

```bash
git add claude/claude.sh
git commit -m "feat: add humanizer skill install to claude.sh"
```

---

### Task 5: Wire `claude/claude.sh` into `install.sh`

**Files:**
- Modify: `install.sh`

- [ ] **Step 1: Add the claude setup section to `install.sh`**

Append the following block before the final `echo "==> Done! Run: source ~/.zshrc"` line in `install.sh`:

```bash
# --- Claude Code plugins ---
bash "$DOTFILES_DIR/claude/claude.sh"
```

- [ ] **Step 2: Run `install.sh` end-to-end and verify all steps complete**

```bash
bash install.sh
```

Expected output includes:
```
==> Setting up dotfiles...
==> Setting up Claude Code plugins...
==> superpowers already installed, skipping
==> caveman already installed, skipping
==> Updating humanizer skill...
Already up to date.
==> Done.
==> Done! Run: source ~/.zshrc
```

- [ ] **Step 3: Commit**

```bash
git add install.sh
git commit -m "feat: wire claude plugin setup into install.sh"
```
