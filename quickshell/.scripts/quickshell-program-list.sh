#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
FLATPAK_USER="$HOME/.local/share/flatpak/exports/share"
FLATPAK_SYSTEM="/var/lib/flatpak/exports/share"

IFS=':' read -r -a DIRS <<<"$DATA_HOME:$DATA_DIRS:$FLATPAK_USER:$FLATPAK_SYSTEM"
DESKTOP_ENV="${XDG_CURRENT_DESKTOP:-}"

HAS_FLATPAK=0
command -v flatpak >/dev/null 2>&1 && HAS_FLATPAK=1

for base in "${DIRS[@]}"; do
    appdir="$base/applications"
    [[ -d "$appdir" ]] || continue
    find "$appdir" \( -type f -o -type l \) -name '*.desktop' -print 2>/dev/null
done |
    awk -v env="$DESKTOP_ENV" -v has_flatpak="$HAS_FLATPAK" -f "$SCRIPT_DIR/quickshell-program-list.awk"
