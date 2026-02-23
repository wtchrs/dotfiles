BEGIN {
    first = 1
    printf "["

    n = split(env, tmp, ":")
    for (i = 1; i <= n; i++) if (tmp[i] != "") env_set[tmp[i]] = 1
}

function json_escape(s) {
    gsub(/\\/, "\\\\", s)
    gsub(/"/, "\\\"", s)
    gsub(/\t/, "\\t", s)
    gsub(/\r/, "\\r", s)
    gsub(/\n/, "\\n", s)
    return s
}

function sh_escape(s) {
    gsub(/\\/, "\\\\", s)
    gsub(/"/, "\\\"", s)
    gsub(/\$/, "\\$", s)
    gsub(/`/, "\\`", s)
    return s
}

function cmd_exists(cmd,   q, rc) {
    if (cmd in cmd_cache) return cmd_cache[cmd]
    q = sh_escape(cmd)
    rc = system("command -v \"" q "\" >/dev/null 2>&1")
    cmd_cache[cmd] = (rc == 0)
    return cmd_cache[cmd]
}

function parse_desktop(file,   line, in_entry, valid, is_flatpak, name, exec, icon, desc, tryexec, cmd, ok, i, arr) {
    in_entry = 0
    valid = 1
    is_flatpak = 0
    name = exec = icon = desc = ""

    while ((getline line < file) > 0) {
        sub(/\r$/, "", line)

        if (!in_entry) {
            if (line == "[Desktop Entry]") in_entry = 1
            continue
        }
        if (line ~ /^\[/) break

        if (line ~ /^Type=/ && line != "Type=Application") { valid = 0; break }
        if (line == "Hidden=true" || line == "NoDisplay=true") { valid = 0; break }

        if (line ~ /^OnlyShowIn=/) {
            split(substr(line, 12), arr, ";")
            ok = 0
            for (i in arr) {
                if (arr[i] == "") continue
                if ((arr[i] in env_set) || arr[i] == env) { ok = 1; break }
            }
            if (!ok) { valid = 0; break }
            continue
        }

        if (line ~ /^NotShowIn=/) {
            if (env != "") {
                split(substr(line, 11), arr, ";")
                for (i in arr) {
                    if (arr[i] == "") continue
                    if ((arr[i] in env_set) || arr[i] == env) { valid = 0; break }
                }
                if (!valid) break
            }
            continue
        }

        if (line ~ /^X-Flatpak=/) { is_flatpak = 1; continue }

        if (line ~ /^Exec=/ && exec == "") {
            exec = substr(line, 6)
            if (exec ~ /(^|\/)flatpak[[:space:]]+run/) is_flatpak = 1
            continue
        }

        if (line ~ /^TryExec=/) {
            if (is_flatpak) continue
            tryexec = substr(line, 9)
            sub(/[ \t].*$/, "", tryexec) # only the first argument (program name)
            cmd = tryexec

            if (cmd == "flatpak" || cmd ~ /\/flatpak$/) {
                if (!has_flatpak) { valid = 0; break }
            } else {
                if (!cmd_exists(cmd)) { valid = 0; break }
            }
            continue
        }

        if (line ~ /^Name=/ && name == "") { name = substr(line, 6); continue }
        if (line ~ /^Icon=/ && icon == "") { icon = substr(line, 6); continue }
        if ((line ~ /^Description=/ || line ~ /^Comment=/) && desc == "") {
            desc = substr(line, index(line, "=") + 1)
            continue
        }
    }
    close(file)

    if (!valid || name == "" || exec == "") return

    gsub(/%[a-zA-Z]/, "", exec)
    gsub(/^[ \t]+/, "", exec)
    gsub(/[ \t]+$/, "", exec)

    if (!first) printf ","
    first = 0

    printf "{\"name\":\"%s\",\"exec\":\"%s\",\"icon\":\"%s\",\"description\":\"%s\"}",
           json_escape(name), json_escape(exec), json_escape(icon), json_escape(desc)
}

{
    file = $0
    if (file == "") next

    # deduplicate basename: prefer the first one
    base = file
    sub(/^.*\//, "", base)
    if (base in seen) next
    seen[base] = 1

    parse_desktop(file)
}

END {
    print "]"
}
