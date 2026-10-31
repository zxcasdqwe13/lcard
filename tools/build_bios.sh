#!/usr/bin/env bash
#
# Build ADI_DSP/E440.BIO with the original DOS toolchain (asm21/ld21/bin3pci)
# running inside DOSBox. On Windows, ADI_DSP/GoDsp.bat does the same.
#
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/ADI_DSP"
CLEAN=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [--clean]

  --clean   remove DOS build intermediates after a successful build

Requires: dosbox (0.74 or newer).
EOF
}

while (($#)); do
    case "$1" in
        --clean) CLEAN=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown argument: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

if ! command -v dosbox >/dev/null 2>&1; then
    echo "error: dosbox not found in PATH" >&2
    exit 1
fi
if [[ ! -f "$SRC/GoDsp.bat" ]]; then
    echo "error: $SRC/GoDsp.bat not found; wrong repository layout?" >&2
    exit 1
fi
if [[ ! -f "$SRC/E440.DSP" ]]; then
    echo "error: $SRC/E440.DSP not found" >&2
    exit 1
fi

WORK_DIR="$(mktemp -d /tmp/e440-build.XXXXXX)"
MARKER="$WORK_DIR/marker"
LOG="$WORK_DIR/dosbox.log"
CONF="$WORK_DIR/dosbox.conf"
ln -s "$ROOT" "$WORK_DIR/repo"
touch "$MARKER"
trap 'rm -rf "$WORK_DIR"' EXIT

# Use an isolated config: the user's ~/.dosbox config may use cycles=auto,
# which hangs on some headless systems. waitonerror=false also keeps DOSBox
# from blocking on an invisible modal dialog.
cat >"$CONF" <<'EOF'
[sdl]
output=surface
fullscreen=false
waitonerror=false
[dosbox]
machine=svga_s3
[cpu]
cycles=max
[mixer]
nosound=true
EOF

# DOSBox mounts the repository root as C: so that the paths from GoDsp.bat
# (C:\ADI_DSP\21XX\...) stay valid. A space-free symlink is used because
# DOSBox 0.74 hangs on a quoted mount path.
#
# Note: DOSBox exits with status 0 even if the assembler failed, so success is
# verified by checking that E440.BIO was actually rewritten.
echo "Building E440.BIO in DOSBox..."
BUILD_TIMEOUT="${E440_BUILD_TIMEOUT:-60}"

# DOSBox 0.74 does not always terminate after GoDsp.bat returns (the queued
# -c exit command is lost after a batch file). Run it in the background and
# stop it once E440.BIO has appeared and its size/mtime stayed stable for
# about a second, i.e. bin3pci definitely finished writing.
SDL_VIDEODRIVER="${SDL_VIDEODRIVER:-dummy}" \
SDL_AUDIODRIVER="${SDL_AUDIODRIVER:-dummy}" \
dosbox -conf "$CONF" \
    -c "mount c $WORK_DIR/repo" \
    -c "c:" \
    -c "cd ADI_DSP" \
    -c "GoDsp.bat" \
    >"$LOG" 2>&1 &
DBPID=$!

fresh=0
stable=0
prev=""
deadline=$((SECONDS + BUILD_TIMEOUT))
while ((SECONDS < deadline)); do
    if ! kill -0 "$DBPID" 2>/dev/null; then
        break
    fi
    if [[ -f "$SRC/E440.BIO" && "$SRC/E440.BIO" -nt "$MARKER" ]]; then
        cur="$(stat -c '%Y:%s' "$SRC/E440.BIO")"
        if [[ "$cur" == "$prev" ]]; then
            stable=$((stable + 1))
        else
            stable=0
            prev="$cur"
        fi
        if ((stable >= 3)); then
            fresh=1
            break
        fi
    fi
    sleep 0.25
done

if kill -0 "$DBPID" 2>/dev/null; then
    kill "$DBPID" 2>/dev/null || true
fi
wait "$DBPID" 2>/dev/null || true

if [[ $fresh -ne 1 ]] || [[ ! -f "$SRC/E440.BIO" ]] || [[ ! "$SRC/E440.BIO" -nt "$MARKER" ]]; then
    echo "error: E440.BIO was not produced; check assembler output" >&2
    tail -20 "$LOG" >&2 || true
    echo "       run GoDsp.bat/asm21 manually for details" >&2
    exit 1
fi

if ((CLEAN)); then
    rm -f "$SRC"/*.obj "$SRC"/*.OBJ "$SRC"/*.cde "$SRC"/*.CDE \
          "$SRC"/*.int "$SRC"/*.INT "$SRC"/*.bak "$SRC"/*.BAK \
          "$SRC"/*.sym "$SRC"/*.SYM "$SRC"/e440.exe "$SRC"/inttable.exe
fi

echo "OK: $SRC/E440.BIO ($(stat -c%s "$SRC/E440.BIO") bytes, md5 $(md5sum "$SRC/E440.BIO" | cut -d' ' -f1))"
