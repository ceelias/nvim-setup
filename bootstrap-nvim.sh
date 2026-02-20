#!/usr/bin/env bash
set -euo pipefail

# Expects these files next to this script:
#   - plugins.lua
#   - keymaps.lua
#
# This script:
# - installs lazy.nvim (if missing)
# - disables old packer dir (renames it) to avoid plugin conflicts
# - copies your plugins.lua + keymaps.lua into ~/.config/nvim/lua/
# - writes init.lua + config.lua
# - IMPORTANT: init.lua loads plugins FIRST, then config/keymaps
#
# Usage:
#   chmod +x bootstrap-nvim.sh
#   ./bootstrap-nvim.sh

NVIM_BIN="${NVIM_BIN:-nvim}"

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REQ_PLUGINS="$SRC_DIR/plugins.lua"
REQ_KEYMAPS="$SRC_DIR/keymaps.lua"

NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
LUA_DIR="$NVIM_DIR/lua"

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
LAZY_DIR="$DATA_DIR/lazy/lazy.nvim"
PACKER_DIR="$DATA_DIR/site/pack/packer"

ts() { date +"%Y%m%d_%H%M%S"; }
die() { echo "ERROR: $*" >&2; exit 1; }
have_cmd() { command -v "$1" >/dev/null 2>&1; }

backup_if_exists() {
  local f="$1"
  if [[ -f "$f" ]]; then
    local b="${f}.bak.$(ts)"
    echo "Backing up $f -> $b"
    mv "$f" "$b"
  fi
}

need_file() {
  local f="$1"
  [[ -f "$f" ]] || die "Missing required file: $f (must be in the same directory as this script)"
}

echo "==> Checking prerequisites"
need_file "$REQ_PLUGINS"
need_file "$REQ_KEYMAPS"

have_cmd "$NVIM_BIN" || die "'$NVIM_BIN' not found in PATH. Install neovim and rerun."
have_cmd git || die "git not found. Install git and rerun."

echo "==> Creating Neovim config directories"
mkdir -p "$LUA_DIR"
mkdir -p "$(dirname "$LAZY_DIR")"

echo "==> Disabling old packer plugins if present (prevents treesitter conflicts)"
if [[ -d "$PACKER_DIR" ]]; then
  bak="${PACKER_DIR}.bak.$(ts)"
  mv "$PACKER_DIR" "$bak"
  echo "Renamed $PACKER_DIR -> $bak"
fi

echo "==> Installing lazy.nvim if missing"
if [[ ! -d "$LAZY_DIR" ]]; then
  git clone https://github.com/folke/lazy.nvim "$LAZY_DIR"
else
  echo "lazy.nvim already installed at $LAZY_DIR"
fi

echo "==> Writing init.lua + config.lua (plugins FIRST)"
backup_if_exists "$NVIM_DIR/init.lua"
cat > "$NVIM_DIR/init.lua" <<'LUA'
-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- Load plugins first so keymaps can reference them safely
require("plugins")
require("config")
LUA

backup_if_exists "$LUA_DIR/config.lua"
cat > "$LUA_DIR/config.lua" <<'LUA'
require("keymaps")
LUA

echo "==> Copying your plugins.lua + keymaps.lua into ~/.config/nvim/lua/"
backup_if_exists "$LUA_DIR/plugins.lua"
backup_if_exists "$LUA_DIR/keymaps.lua"

cp "$REQ_PLUGINS" "$LUA_DIR/plugins.lua"
cp "$REQ_KEYMAPS" "$LUA_DIR/keymaps.lua"

echo
echo "Done."
echo "Next:"
echo "  1) Run: $NVIM_BIN"
echo "  2) Then run inside nvim: :Lazy sync"
echo "  3) Restart nvim"
