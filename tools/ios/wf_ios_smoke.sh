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
WF_USE_DEBUG_OVERLAY=${WF_USE_DEBUG_OVERLAY:-1}
WF_NOCACHE=${WF_NOCACHE:-1}
WF_ADVANCE_TIMEOUT=${WF_ADVANCE_TIMEOUT:-0}
WF_START_SCENARIO=${WF_START_SCENARIO:-A_New_Beginning}
WF_NEXT_SCENARIO=${WF_NEXT_SCENARIO:-Summer_of_Dreams}
WF_WAIT_FOR_SCENARIO_END=${WF_WAIT_FOR_SCENARIO_END:-0}
WF_SCENARIO_END_TIMEOUT=${WF_SCENARIO_END_TIMEOUT:-300}
WF_FORCE_KEEP=${WF_FORCE_KEEP:-0}
WF_FORCE_SEASON_END=${WF_FORCE_SEASON_END:-0}

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

inject_debug_overlay() {
  local scenario_path=$1
  local scenario_id=$2
  local temp_path="$scenario_path.tmp"

  awk -v scenario_id="$scenario_id" -v force_keep="$WF_FORCE_KEEP" -v force_season_end="$WF_FORCE_SEASON_END" '
    /^\[\/scenario\]$/ && !inserted {
      print ""
      print "[event]"
      print "    name=start"
      print "    [modify_side]"
      print "        side=1"
      print "        fog=no"
      print "        shroud=no"
      print "        suppress_end_turn_confirmation=yes"
      print "    [/modify_side]"
      print "    [lua]"
      print "        code=<<"
      print "            wesnoth.log(\"warning\", \"WF_AUTOMATION overlay_ready scenario=" scenario_id "\")"
      print "        >>"
      print "    [/lua]"
      print "[/event]"
      if (scenario_id == "A_New_Beginning" && force_keep == "1") {
        print ""
        print "[event]"
        print "    name=start"
        print "    [store_unit]"
        print "        [filter]"
        print "            id=Hero"
        print "        [/filter]"
        print "        variable=wf_automation.hero"
        print "    [/store_unit]"
        print "    [terrain]"
        print "        x,y=$wf_automation.hero.x,$wf_automation.hero.y"
        print "        terrain=Ke^Yk"
        print "    [/terrain]"
        print "    [set_variable]"
        print "        name=wf_vars.town_name"
        print "        value=Town center"
        print "    [/set_variable]"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION event=force_keep scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        print "    [clear_variable]"
        print "        name=wf_automation.hero"
        print "    [/clear_variable]"
        print "[/event]"
      }
      print ""
      print "[event]"
      print "    name=side 1 turn refresh"
      print "    first_time_only=no"
      print "    [lua]"
      print "        code=<<"
      print "            wesnoth.log(\"warning\", \"WF_AUTOMATION side1_turn_refresh scenario=" scenario_id " turn=\" .. tostring(wml.variables[\"turn_number\"]))"
      print "        >>"
      print "    [/lua]"
      if (scenario_id == "A_New_Beginning" && force_season_end == "1") {
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION event=force_season_end scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        print "    [fire_event]"
        print "        name=wf_time_over"
        print "    [/fire_event]"
      } else {
        print "    [end_turn]"
        print "    [/end_turn]"
      }
      print "[/event]"
      print ""
      print "[event]"
      print "    name=wf_time_over"
      print "    [lua]"
      print "        code=<<"
      print "            local next_scenario = tostring(wml.variables[\"wf_vars.next_scenario\"] or \"\")"
      print "            wesnoth.log(\"warning\", \"WF_AUTOMATION event=wf_time_over scenario=" scenario_id " next=\" .. next_scenario)"
      print "        >>"
      print "    [/lua]"
      print "[/event]"
      print ""
      print "[event]"
      print "    name=wf_victory"
      print "    [lua]"
      print "        code=<<"
      print "            local next_scenario = tostring(wml.variables[\"wf_vars.next_scenario\"] or \"\")"
      print "            wesnoth.log(\"warning\", \"WF_AUTOMATION event=wf_victory scenario=" scenario_id " next=\" .. next_scenario)"
      print "        >>"
      print "    [/lua]"
      print "[/event]"
      print ""
      print "[event]"
      print "    name=time_over"
      print "    [lua]"
      print "        code=<<"
      print "            local next_scenario = tostring(wml.variables[\"wf_vars.next_scenario\"] or \"\")"
      print "            wesnoth.log(\"warning\", \"WF_AUTOMATION event=time_over scenario=" scenario_id " next=\" .. next_scenario)"
      print "        >>"
      print "    [/lua]"
      print "[/event]"
      print ""
      print "[event]"
      print "    name=victory"
      print "    [lua]"
      print "        code=<<"
      print "            local next_scenario = tostring(wml.variables[\"wf_vars.next_scenario\"] or \"\")"
      print "            wesnoth.log(\"warning\", \"WF_AUTOMATION event=victory scenario=" scenario_id " next=\" .. next_scenario)"
      print "        >>"
      print "    [/lua]"
      print "[/event]"
      inserted=1
    }
    { print }
  ' "$scenario_path" > "$temp_path"

  mv "$temp_path" "$scenario_path"
}

sync_addon() {
  local container=$1
  local addon_dir="$container/Library/Application Support/wesnoth.org/iWesnoth/data/add-ons/$WF_ADDON_NAME"
  mkdir -p "$addon_dir"
  rsync -a --delete --exclude='.git/' "$ROOT_DIR/" "$addon_dir/"
  if [[ "$WF_USE_DEBUG_OVERLAY" == "1" ]]; then
    inject_debug_overlay "$addon_dir/scenarios/a_new_beginning.cfg" "A_New_Beginning"
    inject_debug_overlay "$addon_dir/scenarios/summer_of_dreams.cfg" "Summer_of_Dreams"
  fi
}

latest_log() {
  local container=$1
  local log_dir="$container/Library/Application Support/wesnoth.org/iWesnoth/logs"
  ls -1t "$log_dir" 2>/dev/null | head -n 1
}

wait_for_new_log() {
  local container=$1
  local before_log=${2:-}
  local deadline=$((SECONDS + 60))

  while (( SECONDS < deadline )); do
    local current
    current=$(latest_log "$container")
    if [[ -n "$current" && "$current" != "$before_log" ]]; then
      printf '%s\n' "$current"
      return 0
    fi
    sleep 1
  done

  echo "Timed out waiting for a new Wesnoth log" >&2
  return 1
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

wait_for_log_text() {
  local log_path=$1
  local needle=$2
  local timeout=${3:-60}
  local deadline=$((SECONDS + timeout))

  while (( SECONDS < deadline )); do
    if [[ -f "$log_path" ]] && rg -Fq "$needle" "$log_path"; then
      return 0
    fi
    sleep 1
  done

  echo "Timed out waiting for log text: $needle" >&2
  return 1
}

extract_log_turn() {
  local log_path=$1
  local scenario_id=$2

  rg -o "WF_AUTOMATION side1_turn_refresh scenario=${scenario_id} turn=[0-9]+" "$log_path" 2>/dev/null \
    | sed 's/.*=//' \
    | sort -n \
    | tail -n 1
}

extract_turn_number() {
  local text_path=$1

  awk '
    {
      line=$0
      gsub(/[^0-9\/]/, "", line)
      if (line ~ /^[0-9]+\/[0-9]+$/) {
        split(line, parts, "/")
        if ((parts[2] + 0) > 10) {
          print parts[1]
          exit
        }
      }
    }
  ' "$text_path"
}

capture_turn_number() {
  local name=$1
  capture_and_ocr "$name"
  extract_turn_number "$ARTIFACT_DIR/$name.txt"
}

advance_turns() {
  local log_path=$1
  local turns=$2
  local scenario_id=$3
  local initial_turn=1
  local target_turn=$((initial_turn + turns))
  local seen_turn=$initial_turn
  local timeout=$WF_ADVANCE_TIMEOUT
  local use_log=0
  local max_turn=""
  local current_turn=""
  local turn=""
  if (( timeout <= 0 )); then
    timeout=$((120 + (turns * 60)))
  fi
  local deadline=$((SECONDS + timeout))

  capture_and_ocr "turn-$initial_turn"

  while (( SECONDS < deadline )); do
    max_turn=$(extract_log_turn "$log_path" "$scenario_id")
    if [[ -n "$max_turn" ]]; then
      use_log=1
    fi

    if (( use_log == 1 )); then
      if [[ -n "$max_turn" ]]; then
        if (( max_turn > seen_turn )); then
          for turn in $(seq $((seen_turn + 1)) "$max_turn"); do
            capture_and_ocr "turn-$turn"
          done
          seen_turn=$max_turn
        fi
        if (( max_turn >= target_turn )); then
          return 0
        fi
      fi
    else
      current_turn=$(capture_turn_number "turn-scan")
      if [[ -n "$current_turn" ]]; then
        if (( current_turn > target_turn || current_turn > seen_turn + 2 )); then
          sleep 2
          continue
        fi
        if (( current_turn > seen_turn )); then
          capture_and_ocr "turn-$current_turn"
          seen_turn=$current_turn
        fi
        if (( current_turn >= target_turn )); then
          return 0
        fi
      fi
    fi
    sleep 2
  done

  echo "Timed out waiting to reach side 1 turn $target_turn" >&2
  return 1
}

main() {
  build_helper
  ensure_simulator

  local container
  container=$(find_container)
  sync_addon "$container"

  local before_log
  before_log=$(latest_log "$container")

  local -a launch_args
  launch_args=(--strict-lua --campaign="$WF_ADDON_NAME" --campaign-difficulty="$WF_DIFFICULTY" --campaign-skip-story)
  if [[ "$WF_NOCACHE" == "1" ]]; then
    launch_args=(--nocache "${launch_args[@]}")
  fi

  xcrun simctl terminate "$SIMULATOR_UDID" "$WESNOTH_BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl launch "$SIMULATOR_UDID" "$WESNOTH_BUNDLE_ID" "${launch_args[@]}"

  local run_log_name
  run_log_name=$(wait_for_new_log "$container" "$before_log")
  local log_path="$container/Library/Application Support/wesnoth.org/iWesnoth/logs/$run_log_name"

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

  local run_status=0
  advance_turns "$log_path" "$WF_END_TURNS" "$WF_START_SCENARIO" || run_status=$?

  local after_log
  after_log=$(latest_log "$container")
  log_path="$container/Library/Application Support/wesnoth.org/iWesnoth/logs/$after_log"
  cp "$log_path" "$ARTIFACT_DIR/$after_log"
  error_check "$log_path" || run_status=$?

  if [[ "$WF_WAIT_FOR_SCENARIO_END" == "1" ]]; then
    wait_for_log_text "$log_path" "WF_AUTOMATION event=wf_victory scenario=$WF_START_SCENARIO next=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
    wait_for_log_text "$log_path" "WF_AUTOMATION overlay_ready scenario=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
    wait_for_log_text "$log_path" "WF_AUTOMATION side1_turn_refresh scenario=$WF_NEXT_SCENARIO turn=1" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
    capture_and_ocr "transition-$WF_NEXT_SCENARIO"
  fi

  local reached_turn
  reached_turn=$(extract_log_turn "$log_path" "$WF_START_SCENARIO")
  if [[ -z "$reached_turn" && -f "$ARTIFACT_DIR/turn-scan.txt" ]]; then
    reached_turn=$(extract_turn_number "$ARTIFACT_DIR/turn-scan.txt")
  fi

  {
    echo "artifact_dir=$ARTIFACT_DIR"
    echo "container=$container"
    echo "before_log=$before_log"
    echo "after_log=$after_log"
    echo "turns=$WF_END_TURNS"
    echo "reached_turn=$reached_turn"
    echo "run_status=$run_status"
  } | tee "$ARTIFACT_DIR/summary.txt"

  return "$run_status"
}

main "$@"
