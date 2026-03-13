#!/bin/zsh
set -euo pipefail

SCRIPT_DIR=${0:A:h}
ROOT_DIR=${SCRIPT_DIR:h:h}
IOS_DIR="$ROOT_DIR/tools/ios"
HELPER_SRC="$IOS_DIR/sim_key.m"
HELPER_BIN="$IOS_DIR/sim_key"
OCR_SRC="$IOS_DIR/sim_ocr.swift"
OCR_BIN="$IOS_DIR/sim_ocr"

SIMULATOR_UDID=${SIMULATOR_UDID:-1EE34458-4622-4B5A-9653-8B9BB5AA3415}
WESNOTH_BUNDLE_ID=${WESNOTH_BUNDLE_ID:-org.wesnoth.Wesnoth}
WF_ADDON_NAME=${WF_ADDON_NAME:-Wild_Frontiers}
WF_DIFFICULTY=${WF_DIFFICULTY:-2}
WF_BONUS_DOWN_COUNT=${WF_BONUS_DOWN_COUNT:-12}
WF_END_TURNS=${WF_END_TURNS:-2}
WF_ARTIFACT_ROOT=${WF_ARTIFACT_ROOT:-$ROOT_DIR/working/ios-smoke}
WF_LAUNCH_DELAY=${WF_LAUNCH_DELAY:-8}

timestamp=$(date +"%Y%m%d-%H%M%S")
ARTIFACT_DIR="$WF_ARTIFACT_ROOT/$timestamp"
mkdir -p "$ARTIFACT_DIR"

build_helper() {
  if [[ ! -x "$HELPER_BIN" || "$HELPER_SRC" -nt "$HELPER_BIN" ]]; then
    clang -fobjc-arc -framework Foundation -framework AppKit -o "$HELPER_BIN" "$HELPER_SRC"
  fi

  if [[ ! -x "$OCR_BIN" || "$OCR_SRC" -nt "$OCR_BIN" ]]; then
    swiftc -framework Vision -framework AppKit -o "$OCR_BIN" "$OCR_SRC"
  fi
}

sim_booted() {
  xcrun simctl list devices | rg -q "${SIMULATOR_UDID}.*Booted"
}

ensure_simulator() {
  open -a Simulator >/dev/null 2>&1 || true
  if ! sim_booted; then
    xcrun simctl boot "$SIMULATOR_UDID" >/dev/null 2>&1 || true
    for _ in $(seq 1 20); do
      if sim_booted; then
        break
      fi
      sleep 1
    done
  fi
}

send_key() {
  local key=$1
  local count=${2:-1}
  local modifiers=${3:-}
  "$HELPER_BIN" "$SIMULATOR_UDID" "$key" "$count" "$modifiers"
}

capture_screenshot() {
  local name=$1
  xcrun simctl io "$SIMULATOR_UDID" screenshot "$ARTIFACT_DIR/$name.png" >/dev/null 2>&1
}

ocr_screenshot() {
  local image_path=$1
  "$OCR_BIN" "$image_path"
}

capture_and_ocr() {
  local name=$1
  local image_path="$ARTIFACT_DIR/$name.png"
  local text_path="$ARTIFACT_DIR/$name.txt"
  xcrun simctl io "$SIMULATOR_UDID" screenshot "$image_path" >/dev/null 2>&1
  ocr_screenshot "$image_path" | tee "$text_path" >/dev/null
}

wait_for_text() {
  local needle=$1
  local name=$2
  local timeout=${3:-90}
  local deadline=$((SECONDS + timeout))

  while (( SECONDS < deadline )); do
    capture_and_ocr "$name"
    if rg -Fqi "$needle" "$ARTIFACT_DIR/$name.txt"; then
      return 0
    fi
    sleep 2
  done

  echo "Timed out waiting for text: $needle" >&2
  return 1
}

wait_until_clear() {
  local name=$1
  local timeout=$2
  shift 2
  local deadline=$((SECONDS + timeout))

  while (( SECONDS < deadline )); do
    local matched=0
    capture_and_ocr "$name"
    for needle in "$@"; do
      if rg -Fqi "$needle" "$ARTIFACT_DIR/$name.txt"; then
        matched=1
        break
      fi
    done
    if (( matched == 0 )); then
      return 0
    fi
    sleep 2
  done

  echo "Timed out waiting for screen to clear: $*" >&2
  return 1
}

find_container() {
  xcrun simctl get_app_container "$SIMULATOR_UDID" "$WESNOTH_BUNDLE_ID" data
}

sync_addon() {
  local container=$1
  local addon_dir="$container/Library/Application Support/wesnoth.org/iWesnoth/data/add-ons/$WF_ADDON_NAME"
  mkdir -p "$addon_dir"
  rsync -a --delete --exclude='.git/' "$ROOT_DIR/" "$addon_dir/"
}

latest_log() {
  local container=$1
  local log_dir="$container/Library/Application Support/wesnoth.org/iWesnoth/logs"
  ls -1t "$log_dir" 2>/dev/null | head -n 1
}

error_check() {
  local log_path=$1
  if rg -n "error scripting/lua:|error wml:|Error occured inside|traceback|critical|fatal" "$log_path" >"$ARTIFACT_DIR/errors.txt"; then
    echo "Errors found in $log_path"
    cat "$ARTIFACT_DIR/errors.txt"
    return 1
  fi
  rm -f "$ARTIFACT_DIR/errors.txt"
}

advance_turns() {
  local turns=$1
  local turn
  for turn in $(seq 1 "$turns"); do
    send_key space 1 option
    sleep 1
    send_key return
    sleep 6
    capture_and_ocr "turn-$turn"
  done
}

main() {
  build_helper
  ensure_simulator

  local container
  container=$(find_container)
  sync_addon "$container"

  local before_log
  before_log=$(latest_log "$container")

  xcrun simctl terminate "$SIMULATOR_UDID" "$WESNOTH_BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl launch "$SIMULATOR_UDID" "$WESNOTH_BUNDLE_ID" \
    --strict-lua \
    --campaign="$WF_ADDON_NAME" \
    --campaign-difficulty="$WF_DIFFICULTY" \
    --campaign-skip-story

  sleep "$WF_LAUNCH_DELAY"
  wait_for_text "Which type would you like to use?" "economy-dialog" 180

  send_key return
  wait_for_text "Nevermind" "bonus-dialog" 90

  send_key down "$WF_BONUS_DOWN_COUNT"
  send_key return
  send_key return
  wait_until_clear "post-start" 120 \
    "Which type would you like to use?" \
    "Nevermind" \
    "Starting game..." \
    "Reading files and creating cache..."

  advance_turns "$WF_END_TURNS"

  local after_log
  after_log=$(latest_log "$container")
  local log_path="$container/Library/Application Support/wesnoth.org/iWesnoth/logs/$after_log"
  cp "$log_path" "$ARTIFACT_DIR/$after_log"
  error_check "$log_path"

  {
    echo "artifact_dir=$ARTIFACT_DIR"
    echo "container=$container"
    echo "before_log=$before_log"
    echo "after_log=$after_log"
    echo "turns=$WF_END_TURNS"
  } | tee "$ARTIFACT_DIR/summary.txt"
}

main "$@"
