#!/usr/bin/env bash
# Replace the GDM login-screen background on GNOME (Fedora).
#
#   sudo ./gdm-bg.sh /path/to/wallpaper.png
#   sudo ./gdm-bg.sh --restore
#
# Requires: glib2-devel (glib-compile-resources), glib2 (gresource)
set -euo pipefail

GRES=/usr/share/gnome-shell/gnome-shell-theme.gresource
BACKUP=${GRES}.orig

[[ $EUID -eq 0 ]] || {
  echo "must run as root" >&2
  exit 1
}

if [[ ${1:-} == --restore ]]; then
  [[ -f $BACKUP ]] || {
    echo "no backup at $BACKUP" >&2
    exit 1
  }
  cp -f "$BACKUP" "$GRES"
  chmod 644 "$GRES"
  command -v restorecon >/dev/null && restorecon "$GRES"
  echo "restored -- log out or reboot to see it"
  exit 0
fi

IMG=${1:?usage: $0 /path/to/image | --restore}
[[ -f $IMG ]] || {
  echo "no such file: $IMG" >&2
  exit 1
}

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"

# 1. extract the shipped theme
for r in $(gresource list "$GRES"); do
  rel=${r#/org/gnome/shell/}
  mkdir -p "$(dirname "$rel")"
  gresource extract "$GRES" "$r" >"$rel"
done

# 2. drop the image in and point the login dialog at it
cp "$IMG" theme/background
for css in theme/gnome-shell-dark.css theme/gnome-shell-light.css theme/gnome-shell.css; do
  [[ -f $css ]] || continue
  cat >>"$css" <<'EOF'

#lockDialogGroup {
  background-image: url('resource:///org/gnome/shell/theme/background');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
}
EOF
done

# 3. rebuild the manifest from whatever is actually present (version-agnostic)
{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<gresources>'
  echo '  <gresource prefix="/org/gnome/shell">'
  find theme -type f | sort | sed 's|.*|    <file>&</file>|'
  echo '  </gresource>'
  echo '</gresources>'
} >gnome-shell-theme.gresource.xml

glib-compile-resources --sourcedir=. gnome-shell-theme.gresource.xml

# 4. install (cp, not mv -- mv carries the wrong SELinux label and GDM white-screens)
[[ -f $BACKUP ]] || cp -a "$GRES" "$BACKUP"
cp -f gnome-shell-theme.gresource "$GRES"
chmod 644 "$GRES"
command -v restorecon >/dev/null && restorecon "$GRES"

echo "done -- log out or reboot to see it"
