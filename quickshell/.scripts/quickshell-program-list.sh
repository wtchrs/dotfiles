#!/usr/bin/env bash
set -euo pipefail

DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
FLATPAK_USER="$HOME/.local/share/flatpak/exports/share"
FLATPAK_SYSTEM="/var/lib/flatpak/exports/share"
IFS=':' read -ra DIRS <<<"$DATA_HOME:$DATA_DIRS:$FLATPAK_USER:$FLATPAK_SYSTEM"

DESKTOP_ENV="${XDG_CURRENT_DESKTOP:-}"

declare -A seen
first=1

json_escape() {
    printf '%s' "$1" | sed \
        -e 's/\\/\\\\/g' \
        -e 's/"/\\"/g' \
        -e 's/\t/\\t/g' \
        -e 's/\r/\\r/g' \
        -e 's/\n/\\n/g'
}

printf '[\n'

AWK_SCRIPT='
BEGIN {
    in_entry = 0
    valid = 1
    is_flatpak = 0
}

/^\[Desktop Entry\]/ {
    in_entry = 1
    next
}

/^\[/ && in_entry { exit }
!in_entry { next }

/^Type=/ && $0 != "Type=Application" { valid = 0 }
/^Hidden=true/ { valid = 0 }
/^NoDisplay=true/ { valid = 0 }

/^OnlyShowIn=/ {
    split(substr($0,12), a, ";")
    ok = 0
    for (i in a) if (a[i] == env) ok = 1
    if (!ok) valid = 0
}

/^NotShowIn=/ {
    split(substr($0,11), a, ";")
    for (i in a) if (a[i] == env) valid = 0
}

/^X-Flatpak=/ {
    is_flatpak = 1
    next
}

/^Exec=/ && exec == "" {
    exec = substr($0,6)
    if (exec ~ /(^|\/)flatpak[[:space:]]+run/)
        is_flatpak = 1
}

/^TryExec=/ {
    if (is_flatpak)
        next
    split(substr($0,9), t, /[ \t]+/)
    cmd = t[1]
    if (cmd == "flatpak" || cmd ~ /\/flatpak$/) {
        if (system("command -v flatpak >/dev/null 2>&1") != 0)
            valid = 0
    } else {
        if (system("command -v \"" cmd "\" >/dev/null 2>&1") != 0)
            valid = 0
    }
}

/^Name(\[.*\])?=/ && name == "" {
    if ($0 ~ /^Name=/)
        name = substr($0,6)
}

/^Icon=/ && icon == "" {
    icon = substr($0,6)
}

/^(Description|Comment)(\[.*\])?=/ && desc == "" {
    if ($0 ~ /^(Description|Comment)=/)
        desc = substr($0, index($0, "=") + 1)
}

END {
    if (!valid || name == "" || exec == "") exit 0

    gsub(/%[a-zA-Z]/, "", exec)
    gsub(/^[ \t]+|[ \t]+$/, "", exec)

    printf "%s\034%s\034%s\034%s\n", name, exec, icon, desc
}
'

for base in "${DIRS[@]}"; do
    appdir="$base/applications"
    [ -d "$appdir" ] || continue

    while IFS= read -r file; do
        fname="$(basename "$file")"
        [[ -n "${seen[$fname]:-}" ]] && continue
        seen[$fname]=1

        while IFS=$'\034' read -r name exec icon desc; do
            if ((first == 0)); then
                printf ',\n'
            fi
            first=0

            printf '  {'
            printf '"name":"%s",' "$(json_escape "$name")"
            printf '"exec":"%s",' "$(json_escape "$exec")"
            printf '"icon":"%s",' "$(json_escape "$icon")"
            printf '"description":"%s"' "$(json_escape "$desc")"
            printf '}'
        done < <(
            awk -v env="$DESKTOP_ENV" "$AWK_SCRIPT" "$file"
        )

    done < <(
        find "$appdir" \( -type f -o -type l \) -name '*.desktop' 2>/dev/null
    )
done

printf '\n]\n'
