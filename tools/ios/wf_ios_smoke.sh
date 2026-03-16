#!/bin/zsh
set -euo pipefail
set +x

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
WF_CALAMITY_DIALOG_ADVANCES=${WF_CALAMITY_DIALOG_ADVANCES:-6}
WF_USE_DEBUG_OVERLAY=${WF_USE_DEBUG_OVERLAY:-1}
WF_NOCACHE=${WF_NOCACHE:-1}
WF_ADVANCE_TIMEOUT=${WF_ADVANCE_TIMEOUT:-0}
WF_START_SCENARIO=${WF_START_SCENARIO:-A_New_Beginning}
WF_NEXT_SCENARIO=${WF_NEXT_SCENARIO:-Summer_of_Dreams}
WF_CHAIN_SCENARIO_2=${WF_CHAIN_SCENARIO_2:-}
WF_CHAIN_SCENARIO_3=${WF_CHAIN_SCENARIO_3:-}
WF_CHAIN_SCENARIO_4=${WF_CHAIN_SCENARIO_4:-}
WF_CHAIN_SCENARIO_5=${WF_CHAIN_SCENARIO_5:-}
WF_CHAIN_SCENARIO_6=${WF_CHAIN_SCENARIO_6:-}
WF_CHAIN_SCENARIO_7=${WF_CHAIN_SCENARIO_7:-}
WF_CHAIN_SCENARIO_8=${WF_CHAIN_SCENARIO_8:-}
WF_NEXT_END_TURNS=${WF_NEXT_END_TURNS:-0}
WF_CHAIN_5_END_TURNS=${WF_CHAIN_5_END_TURNS:-0}
WF_CHAIN_6_END_TURNS=${WF_CHAIN_6_END_TURNS:-0}
WF_CHAIN_7_END_TURNS=${WF_CHAIN_7_END_TURNS:-0}
WF_WAIT_FOR_SCENARIO_END=${WF_WAIT_FOR_SCENARIO_END:-0}
WF_SCENARIO_END_TIMEOUT=${WF_SCENARIO_END_TIMEOUT:-300}
WF_FORCE_KEEP=${WF_FORCE_KEEP:-0}
WF_FORCE_SEASON_END=${WF_FORCE_SEASON_END:-0}
WF_FORCE_SUMMER_END=${WF_FORCE_SUMMER_END:-0}
WF_FORCE_SECOND_SUMMER_END_TURN=${WF_FORCE_SECOND_SUMMER_END_TURN:-0}
WF_FORCE_AUTUMN_END=${WF_FORCE_AUTUMN_END:-0}
WF_FORCE_WINTER_END=${WF_FORCE_WINTER_END:-0}
WF_FORCE_SPRING_END=${WF_FORCE_SPRING_END:-0}
WF_FORCE_SUMMER_OUTLAW_RAID=${WF_FORCE_SUMMER_OUTLAW_RAID:-0}
WF_FORCE_SUMMER_BANDIT_RAID=${WF_FORCE_SUMMER_BANDIT_RAID:-0}
WF_FORCE_SUMMER_ORC_RAID=${WF_FORCE_SUMMER_ORC_RAID:-0}
WF_FORCE_SUMMER_UNDEAD_RAID=${WF_FORCE_SUMMER_UNDEAD_RAID:-0}
WF_FORCE_SUMMER_CALAMITY_TYPE=${WF_FORCE_SUMMER_CALAMITY_TYPE:-}
WF_FORCE_SUMMER_GRYPHON_NEST=${WF_FORCE_SUMMER_GRYPHON_NEST:-0}
WF_FORCE_SUMMER_LOYALIST_CAMP=${WF_FORCE_SUMMER_LOYALIST_CAMP:-0}
WF_FORCE_SUMMER_LOYALIST_DITCH_KEEP=${WF_FORCE_SUMMER_LOYALIST_DITCH_KEEP:-0}
WF_FORCE_SUMMER_SAURIAN_KEEP=${WF_FORCE_SUMMER_SAURIAN_KEEP:-0}
WF_FORCE_AUTUMN_ELF_KEEP=${WF_FORCE_AUTUMN_ELF_KEEP:-0}
WF_FORCE_AUTUMN_DWARF_KEEP=${WF_FORCE_AUTUMN_DWARF_KEEP:-0}
WF_FORCE_WINTER_UNDEAD_RAID=${WF_FORCE_WINTER_UNDEAD_RAID:-0}
WF_FORCE_WINTER_ELF_RAID=${WF_FORCE_WINTER_ELF_RAID:-0}
WF_FORCE_WINTER_DWARF_RAID=${WF_FORCE_WINTER_DWARF_RAID:-0}
WF_FORCE_WINTER_RUIN_CASTLE=${WF_FORCE_WINTER_RUIN_CASTLE:-0}
WF_FORCE_SPRING_ORC_RAID=${WF_FORCE_SPRING_ORC_RAID:-0}
WF_FORCE_SPRING_UNDEAD_RAID=${WF_FORCE_SPRING_UNDEAD_RAID:-0}
WF_FORCE_SPRING_DROWNING=${WF_FORCE_SPRING_DROWNING:-0}
WF_WAIT_FOR_SUMMER_OUTLAW_RAID=${WF_WAIT_FOR_SUMMER_OUTLAW_RAID:-0}
WF_WAIT_FOR_SUMMER_BANDIT_RAID=${WF_WAIT_FOR_SUMMER_BANDIT_RAID:-0}
WF_WAIT_FOR_SUMMER_ORC_RAID=${WF_WAIT_FOR_SUMMER_ORC_RAID:-0}
WF_WAIT_FOR_SUMMER_UNDEAD_RAID=${WF_WAIT_FOR_SUMMER_UNDEAD_RAID:-0}
WF_WAIT_FOR_SUMMER_CALAMITY=${WF_WAIT_FOR_SUMMER_CALAMITY:-0}
WF_WAIT_FOR_SUMMER_GRYPHON_NEST=${WF_WAIT_FOR_SUMMER_GRYPHON_NEST:-0}
WF_WAIT_FOR_SUMMER_YETIS=${WF_WAIT_FOR_SUMMER_YETIS:-0}
WF_WAIT_FOR_SUMMER_LOYALIST_CAMP=${WF_WAIT_FOR_SUMMER_LOYALIST_CAMP:-0}
WF_WAIT_FOR_SUMMER_LOYALIST_DITCH_KEEP=${WF_WAIT_FOR_SUMMER_LOYALIST_DITCH_KEEP:-0}
WF_WAIT_FOR_SUMMER_SAURIAN_KEEP=${WF_WAIT_FOR_SUMMER_SAURIAN_KEEP:-0}
WF_WAIT_FOR_AUTUMN_CARRYOVER=${WF_WAIT_FOR_AUTUMN_CARRYOVER:-0}
WF_WAIT_FOR_AUTUMN_ELF_KEEP=${WF_WAIT_FOR_AUTUMN_ELF_KEEP:-0}
WF_WAIT_FOR_AUTUMN_DWARF_KEEP=${WF_WAIT_FOR_AUTUMN_DWARF_KEEP:-0}
WF_WAIT_FOR_SECOND_AUTUMN_CARRYOVER=${WF_WAIT_FOR_SECOND_AUTUMN_CARRYOVER:-0}
WF_WAIT_FOR_WINTER_STATE=${WF_WAIT_FOR_WINTER_STATE:-0}
WF_WAIT_FOR_SECOND_WINTER_STATE=${WF_WAIT_FOR_SECOND_WINTER_STATE:-0}
WF_WAIT_FOR_WINTER_UNDEAD_RAID=${WF_WAIT_FOR_WINTER_UNDEAD_RAID:-0}
WF_WAIT_FOR_WINTER_ELF_RAID=${WF_WAIT_FOR_WINTER_ELF_RAID:-0}
WF_WAIT_FOR_WINTER_DWARF_RAID=${WF_WAIT_FOR_WINTER_DWARF_RAID:-0}
WF_WAIT_FOR_WINTER_RUIN_CASTLE=${WF_WAIT_FOR_WINTER_RUIN_CASTLE:-0}
WF_WAIT_FOR_SECOND_WINTER_UNDEAD_RAID=${WF_WAIT_FOR_SECOND_WINTER_UNDEAD_RAID:-0}
WF_WAIT_FOR_SECOND_WINTER_ELF_RAID=${WF_WAIT_FOR_SECOND_WINTER_ELF_RAID:-0}
WF_WAIT_FOR_SECOND_WINTER_DWARF_RAID=${WF_WAIT_FOR_SECOND_WINTER_DWARF_RAID:-0}
WF_WAIT_FOR_SECOND_WINTER_RUIN_CASTLE=${WF_WAIT_FOR_SECOND_WINTER_RUIN_CASTLE:-0}
WF_WAIT_FOR_SPRING_STATE=${WF_WAIT_FOR_SPRING_STATE:-0}
WF_WAIT_FOR_SECOND_SPRING_STATE=${WF_WAIT_FOR_SECOND_SPRING_STATE:-0}
WF_WAIT_FOR_SPRING_ORC_RAID=${WF_WAIT_FOR_SPRING_ORC_RAID:-0}
WF_WAIT_FOR_SPRING_UNDEAD_RAID=${WF_WAIT_FOR_SPRING_UNDEAD_RAID:-0}
WF_WAIT_FOR_SPRING_DROWNING=${WF_WAIT_FOR_SPRING_DROWNING:-0}
WF_WAIT_FOR_SECOND_SUMMER_STATE=${WF_WAIT_FOR_SECOND_SUMMER_STATE:-0}
WF_FORCE_SUMMER_CALAMITY_SIGHTING=${WF_FORCE_SUMMER_CALAMITY_SIGHTING:-0}
WF_FORCE_SUMMER_CALAMITY_KILL=${WF_FORCE_SUMMER_CALAMITY_KILL:-0}
WF_WAIT_FOR_SUMMER_CALAMITY_SIGHTING=${WF_WAIT_FOR_SUMMER_CALAMITY_SIGHTING:-0}
WF_WAIT_FOR_SUMMER_CALAMITY_KILL=${WF_WAIT_FOR_SUMMER_CALAMITY_KILL:-0}
WF_WAIT_FOR_SUMMER_CALAMITY_AFTERMATH=${WF_WAIT_FOR_SUMMER_CALAMITY_AFTERMATH:-0}
WF_TRACE=${WF_TRACE:-0}

timestamp=$(date +"%Y%m%d-%H%M%S")
ARTIFACT_DIR="$WF_ARTIFACT_ROOT/$timestamp"
mkdir -p "$ARTIFACT_DIR"

if [[ "$WF_TRACE" == "1" ]]; then
  exec 3>"$ARTIFACT_DIR/trace.log"
  XTRACEFD=3
  set -x
fi

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

note_progress() {
  local message=$1
  printf '%s %s\n' "$(date +"%H:%M:%S")" "$message" >> "$ARTIFACT_DIR/progress.log"
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

  awk -v scenario_id="$scenario_id" -v force_keep="$WF_FORCE_KEEP" -v force_season_end="$WF_FORCE_SEASON_END" -v force_summer_end="$WF_FORCE_SUMMER_END" -v force_second_summer_end_turn="$WF_FORCE_SECOND_SUMMER_END_TURN" -v force_autumn_end="$WF_FORCE_AUTUMN_END" -v force_winter_end="$WF_FORCE_WINTER_END" -v force_spring_end="$WF_FORCE_SPRING_END" -v force_summer_outlaw_raid="$WF_FORCE_SUMMER_OUTLAW_RAID" -v force_summer_bandit_raid="$WF_FORCE_SUMMER_BANDIT_RAID" -v force_summer_orc_raid="$WF_FORCE_SUMMER_ORC_RAID" -v force_summer_undead_raid="$WF_FORCE_SUMMER_UNDEAD_RAID" -v force_summer_calamity_type="$WF_FORCE_SUMMER_CALAMITY_TYPE" -v force_summer_gryphon_nest="$WF_FORCE_SUMMER_GRYPHON_NEST" -v force_summer_loyalist_camp="$WF_FORCE_SUMMER_LOYALIST_CAMP" -v force_summer_loyalist_ditch_keep="$WF_FORCE_SUMMER_LOYALIST_DITCH_KEEP" -v force_summer_saurian_keep="$WF_FORCE_SUMMER_SAURIAN_KEEP" -v force_autumn_elf_keep="$WF_FORCE_AUTUMN_ELF_KEEP" -v force_autumn_dwarf_keep="$WF_FORCE_AUTUMN_DWARF_KEEP" -v force_winter_undead_raid="$WF_FORCE_WINTER_UNDEAD_RAID" -v force_winter_elf_raid="$WF_FORCE_WINTER_ELF_RAID" -v force_winter_dwarf_raid="$WF_FORCE_WINTER_DWARF_RAID" -v force_winter_ruin_castle="$WF_FORCE_WINTER_RUIN_CASTLE" -v force_spring_orc_raid="$WF_FORCE_SPRING_ORC_RAID" -v force_spring_undead_raid="$WF_FORCE_SPRING_UNDEAD_RAID" -v force_spring_drowning="$WF_FORCE_SPRING_DROWNING" -v force_summer_calamity_sighting="$WF_FORCE_SUMMER_CALAMITY_SIGHTING" -v force_summer_calamity_kill="$WF_FORCE_SUMMER_CALAMITY_KILL" '
    scenario_id == "Summer_of_Dreams" && force_summer_calamity_type != "" && /\{CALAMITIES_MAY_OCCUR\}/ && !inserted_calamity_prestart {
      print ""
      print "[event]"
      print "    name=prestart"
      print "    [set_variable]"
      print "        name=wf_automation.calamity_type"
      print "        value=" force_summer_calamity_type
      print "    [/set_variable]"
      print "    [set_variable]"
      print "        name=relations.calamity_type"
      print "        value=" force_summer_calamity_type
      print "    [/set_variable]"
      print "    [lua]"
      print "        code=<<"
      print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_force_calamity scenario=" scenario_id " type=" force_summer_calamity_type "\")"
      print "        >>"
      print "    [/lua]"
      print "[/event]"
      inserted_calamity_prestart=1
    }
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
      if (scenario_id == "Summer_of_Dreams") {
        print ""
        print "[event]"
        print "    name=start"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_state scenario=" scenario_id " year=\" .. tostring(wml.variables[\"wf_vars.year\"] or \"\") .. \" drought=\" .. tostring(wml.variables[\"wf_vars.drought\"] or \"\") .. \" calamity_type=\" .. tostring(wml.variables[\"relations.calamity_type\"] or \"\"))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        if (force_summer_calamity_type != "") {
          print ""
          print "[event]"
          print "    name=start"
          print "    [fire_event]"
          print "        name=side 8 turn 9 end"
          print "    [/fire_event]"
          print "[/event]"
          print ""
          print "[event]"
          print "    name=side 8 turn 9 end"
          print "    [lua]"
          print "        code=<<"
          print "            local calamity_type = tostring(wml.variables[\"wf_automation.calamity_type\"] or \"\")"
          print "            local units = wesnoth.units.find_on_map { side = 8 }"
          print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_trigger scenario=" scenario_id " type=\" .. calamity_type .. \" side8_units=\" .. tostring(#units))"
          print "        >>"
          print "    [/lua]"
          print "[/event]"
          if (force_summer_calamity_type == "lich") {
            print ""
            print "[event]"
            print "    name=calamity_lich_sighted"
            print "    first_time_only=no"
            print "    [lua]"
            print "        code=<<"
            print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_sighting scenario=" scenario_id " type=lich event=calamity_lich_sighted\")"
            print "        >>"
            print "    [/lua]"
            print "[/event]"
          }
          if (force_summer_calamity_type == "orcs") {
            print ""
            print "[event]"
            print "    name=calamity_orcs_sighted"
            print "    first_time_only=no"
            print "    [lua]"
            print "        code=<<"
            print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_sighting scenario=" scenario_id " type=orcs event=calamity_orcs_sighted\")"
            print "        >>"
            print "    [/lua]"
            print "[/event]"
          }
          if (force_summer_calamity_type == "drakes") {
            print ""
            print "[event]"
            print "    name=calamity_drakes_sighted"
            print "    first_time_only=no"
            print "    [lua]"
            print "        code=<<"
            print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_sighting scenario=" scenario_id " type=drakes event=calamity_drakes_sighted\")"
            print "        >>"
            print "    [/lua]"
            print "[/event]"
          }
          if (force_summer_calamity_type == "dwarves") {
            print ""
            print "[event]"
            print "    name=calamity_dwarves_sighted"
            print "    first_time_only=no"
            print "    [lua]"
            print "        code=<<"
            print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_sighting scenario=" scenario_id " type=dwarves event=calamity_dwarves_sighted\")"
            print "        >>"
            print "    [/lua]"
            print "[/event]"
          }
          if (force_summer_calamity_type == "loyalists") {
            print ""
            print "[event]"
            print "    name=calamity_loyalists_sighted"
            print "    first_time_only=no"
            print "    [lua]"
            print "        code=<<"
            print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_sighting scenario=" scenario_id " type=loyalists event=calamity_loyalists_sighted\")"
            print "        >>"
            print "    [/lua]"
            print "[/event]"
          }
          if (force_summer_calamity_type == "elves") {
            print ""
            print "[event]"
            print "    name=calamity_elves_sighted"
            print "    first_time_only=no"
            print "    [lua]"
            print "        code=<<"
            print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_sighting scenario=" scenario_id " type=elves event=calamity_elves_sighted\")"
            print "        >>"
            print "    [/lua]"
            print "[/event]"
          }
          if (force_summer_loyalist_ditch_keep == "1" && force_summer_calamity_type == "loyalists") {
            print ""
            print "[event]"
            print "    name=side 8 turn refresh"
            print "    first_time_only=no"
            print "    [filter_condition]"
            print "        [have_unit]"
            print "            side=8"
            print "            role=evil_loyalist"
            print "            canrecruit=no"
            print "        [/have_unit]"
            print "    [/filter_condition]"
            print "    [lua]"
            print "        code=<<"
            print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_loyalist_ditch_keep scenario=" scenario_id "\")"
            print "        >>"
            print "    [/lua]"
            print "[/event]"
          }
          if (force_summer_calamity_kill == "1" && (force_summer_calamity_type == "lich" || force_summer_calamity_type == "orcs" || force_summer_calamity_type == "drakes" || force_summer_calamity_type == "dwarves")) {
            print ""
            print "[event]"
            print "    name=die"
            print "    first_time_only=no"
            print "    [filter]"
            print "        side=8"
            if (force_summer_calamity_type == "lich") {
              print "        role=lich"
            }
            if (force_summer_calamity_type == "orcs") {
              print "        role=orc_calamity_leader"
            }
            if (force_summer_calamity_type == "drakes") {
              print "        role=drake_leader"
            }
            if (force_summer_calamity_type == "dwarves") {
              print "        role=dwarf_calamity_leader"
            }
            print "    [/filter]"
            print "    [filter_second]"
            print "        side=1"
            print "    [/filter_second]"
            print "    [store_gold]"
            print "        side=1"
            print "        variable=wf_automation.aftermath_gold"
            print "    [/store_gold]"
            print "    [lua]"
            print "        code=<<"
            if (force_summer_calamity_type == "lich") {
              print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_aftermath scenario=" scenario_id " type=lich side1_gold=\" .. tostring(wml.variables[\"wf_automation.aftermath_gold\"] or \"\"))"
            }
            if (force_summer_calamity_type == "orcs") {
              print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_aftermath scenario=" scenario_id " type=orcs side1_gold=\" .. tostring(wml.variables[\"wf_automation.aftermath_gold\"] or \"\"))"
            }
            if (force_summer_calamity_type == "drakes") {
              print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_aftermath scenario=" scenario_id " type=drakes side1_gold=\" .. tostring(wml.variables[\"wf_automation.aftermath_gold\"] or \"\"))"
            }
            if (force_summer_calamity_type == "dwarves") {
              print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_aftermath scenario=" scenario_id " type=dwarves side1_gold=\" .. tostring(wml.variables[\"wf_automation.aftermath_gold\"] or \"\"))"
            }
            print "        >>"
            print "    [/lua]"
            print "    [clear_variable]"
            print "        name=wf_automation.aftermath_gold"
            print "    [/clear_variable]"
            print "[/event]"
          }
        }
      }
      if (scenario_id == "Autumn_of_Gold") {
        print ""
        print "[event]"
        print "    name=new_elves_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION autumn_elves_raid scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        if (force_autumn_elf_keep == "1") {
          print "    [store_unit]"
          print "        [filter]"
          print "            side=6"
          print "            role=elf_leader"
          print "            canrecruit=yes"
          print "        [/filter]"
          print "        variable=wf_automation.autumn_elf_leader"
          print "    [/store_unit]"
          print "    [if]"
          print "        [have_unit]"
          print "            side=6"
          print "            role=elf_leader"
          print "            canrecruit=yes"
          print "        [/have_unit]"
          print "        [then]"
          print "            [set_variable]"
          print "                name=wf_automation.autumn_elf_target_x"
          print "                value=$wf_automation.autumn_elf_leader.goto_x"
          print "            [/set_variable]"
          print "            [set_variable]"
          print "                name=wf_automation.autumn_elf_target_y"
          print "                value=$wf_automation.autumn_elf_leader.goto_y"
          print "            [/set_variable]"
          print "            [lua]"
          print "                code=<<"
          print "                    wesnoth.log(\"warning\", \"WF_AUTOMATION autumn_elf_keep_target scenario=" scenario_id " x=\" .. tostring(wml.variables[\"wf_automation.autumn_elf_target_x\"] or \"\") .. \" y=\" .. tostring(wml.variables[\"wf_automation.autumn_elf_target_y\"] or \"\"))"
          print "                >>"
          print "            [/lua]"
          print "            [if]"
          print "                [have_unit]"
          print "                    side=6"
          print "                    role=elf_leader"
          print "                    canrecruit=yes"
          print "                    x=$wf_automation.autumn_elf_target_x"
          print "                    y=$wf_automation.autumn_elf_target_y"
          print "                [/have_unit]"
          print "                [then]"
          print "                    [fire_event]"
          print "                        name=side 6 turn"
          print "                    [/fire_event]"
          print "                [/then]"
          print "                [else]"
          print "                    [move_unit]"
          print "                        side=6"
          print "                        role=elf_leader"
          print "                        canrecruit=yes"
          print "                        to_x=$wf_automation.autumn_elf_target_x"
          print "                        to_y=$wf_automation.autumn_elf_target_y"
          print "                    [/move_unit]"
          print "                [/else]"
          print "            [/if]"
          print "            [fire_event]"
          print "                name=moveto"
          print "                [primary_unit]"
          print "                    x,y=$wf_automation.autumn_elf_target_x,$wf_automation.autumn_elf_target_y"
          print "                [/primary_unit]"
          print "            [/fire_event]"
          print "            [if]"
          print "                [not]"
          print "                    [have_location]"
          print "                        x=$wf_automation.autumn_elf_target_x"
          print "                        y=$wf_automation.autumn_elf_target_y"
          print "                        terrain=Kv"
          print "                    [/have_location]"
          print "                [/not]"
          print "                [then]"
          print "                    {BUILD_SIDE6_KEEP elves Kv Cv $wf_automation.autumn_elf_target_x $wf_automation.autumn_elf_target_y sw,nw,s}"
          print "                [/then]"
          print "            [/if]"
          print "            [if]"
          print "                [have_location]"
          print "                    x=$wf_automation.autumn_elf_target_x"
          print "                    y=$wf_automation.autumn_elf_target_y"
          print "                    terrain=Kv"
          print "                [/have_location]"
          print "                [then]"
          print "                    [lua]"
          print "                        code=<<"
          print "                            wesnoth.log(\"warning\", \"WF_AUTOMATION autumn_elf_keep scenario=" scenario_id " x=\" .. tostring(wml.variables[\"wf_automation.autumn_elf_target_x\"] or \"\") .. \" y=\" .. tostring(wml.variables[\"wf_automation.autumn_elf_target_y\"] or \"\"))"
          print "                        >>"
          print "                    [/lua]"
          print "                [/then]"
          print "            [/if]"
          print "        [/then]"
          print "    [/if]"
          print "    [clear_variable]"
          print "        name=wf_automation.autumn_elf_leader,wf_automation.autumn_elf_target_x,wf_automation.autumn_elf_target_y"
          print "    [/clear_variable]"
        }
        print "[/event]"
        print ""
        print "[event]"
        print "    name=new_dwarves_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION autumn_dwarves_raid scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        if (force_autumn_dwarf_keep == "1") {
          print "    [store_unit]"
          print "        [filter]"
          print "            side=6"
          print "            role=dwarf_leader"
          print "            canrecruit=yes"
          print "        [/filter]"
          print "        variable=wf_automation.autumn_dwarf_leader"
          print "    [/store_unit]"
          print "    [if]"
          print "        [have_unit]"
          print "            side=6"
          print "            role=dwarf_leader"
          print "            canrecruit=yes"
          print "        [/have_unit]"
          print "        [then]"
          print "            [set_variable]"
          print "                name=wf_automation.autumn_dwarf_target_x"
          print "                value=$wf_automation.autumn_dwarf_leader.goto_x"
          print "            [/set_variable]"
          print "            [set_variable]"
          print "                name=wf_automation.autumn_dwarf_target_y"
          print "                value=$wf_automation.autumn_dwarf_leader.goto_y"
          print "            [/set_variable]"
          print "            [lua]"
          print "                code=<<"
          print "                    wesnoth.log(\"warning\", \"WF_AUTOMATION autumn_dwarf_keep_target scenario=" scenario_id " x=\" .. tostring(wml.variables[\"wf_automation.autumn_dwarf_target_x\"] or \"\") .. \" y=\" .. tostring(wml.variables[\"wf_automation.autumn_dwarf_target_y\"] or \"\"))"
          print "                >>"
          print "            [/lua]"
          print "            [if]"
          print "                [have_unit]"
          print "                    side=6"
          print "                    role=dwarf_leader"
          print "                    canrecruit=yes"
          print "                    x=$wf_automation.autumn_dwarf_target_x"
          print "                    y=$wf_automation.autumn_dwarf_target_y"
          print "                [/have_unit]"
          print "                [then]"
          print "                    [fire_event]"
          print "                        name=side 6 turn"
          print "                    [/fire_event]"
          print "                [/then]"
          print "                [else]"
          print "                    [move_unit]"
          print "                        side=6"
          print "                        role=dwarf_leader"
          print "                        canrecruit=yes"
          print "                        to_x=$wf_automation.autumn_dwarf_target_x"
          print "                        to_y=$wf_automation.autumn_dwarf_target_y"
          print "                    [/move_unit]"
          print "                [/else]"
          print "            [/if]"
          print "            [fire_event]"
          print "                name=moveto"
          print "                [primary_unit]"
          print "                    x,y=$wf_automation.autumn_dwarf_target_x,$wf_automation.autumn_dwarf_target_y"
          print "                [/primary_unit]"
          print "            [/fire_event]"
          print "            [if]"
          print "                [not]"
          print "                    [have_location]"
          print "                        x=$wf_automation.autumn_dwarf_target_x"
          print "                        y=$wf_automation.autumn_dwarf_target_y"
          print "                        terrain=Kud"
          print "                    [/have_location]"
          print "                [/not]"
          print "                [then]"
          print "                    {BUILD_SIDE6_KEEP dwarves Kud Cud $wf_automation.autumn_dwarf_target_x $wf_automation.autumn_dwarf_target_y n,se,ne}"
          print "                [/then]"
          print "            [/if]"
          print "            [if]"
          print "                [have_location]"
          print "                    x=$wf_automation.autumn_dwarf_target_x"
          print "                    y=$wf_automation.autumn_dwarf_target_y"
          print "                    terrain=Kud"
          print "                [/have_location]"
          print "                [then]"
          print "                    [lua]"
          print "                        code=<<"
          print "                            wesnoth.log(\"warning\", \"WF_AUTOMATION autumn_dwarf_keep scenario=" scenario_id " x=\" .. tostring(wml.variables[\"wf_automation.autumn_dwarf_target_x\"] or \"\") .. \" y=\" .. tostring(wml.variables[\"wf_automation.autumn_dwarf_target_y\"] or \"\"))"
          print "                        >>"
          print "                    [/lua]"
          print "                [/then]"
          print "            [/if]"
          print "        [/then]"
          print "    [/if]"
          print "    [clear_variable]"
          print "        name=wf_automation.autumn_dwarf_leader,wf_automation.autumn_dwarf_target_x,wf_automation.autumn_dwarf_target_y"
          print "    [/clear_variable]"
        }
        print "[/event]"
      }
      if (scenario_id == "Winter_of_Storms") {
        print ""
        print "[event]"
        print "    name=start"
        print "    [lua]"
        print "        code=<<"
        print "            local wolves = wesnoth.units.find_on_map { side = 2, type = \"Wolf\" }"
        print "            local rats = wesnoth.units.find_on_map { side = 2, type = \"Giant Rat\" }"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION winter_state scenario=" scenario_id " year=\" .. tostring(wml.variables[\"wf_vars.year\"] or \"\") .. \" wolves=\" .. tostring(#wolves) .. \" rats=\" .. tostring(#rats))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=new_undead_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            local leaders = wesnoth.units.find_on_map { side = 7, role = \"undead_leader\" }"
        print "            local leader_type = leaders[1] and tostring(leaders[1].type) or \"\""
        print "            local side7_units = wesnoth.units.find_on_map { side = 7 }"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION winter_undead_raid scenario=" scenario_id " year=\" .. tostring(wml.variables[\"wf_vars.year\"] or \"\") .. \" leader_type=\" .. leader_type .. \" side7_units=\" .. tostring(#side7_units))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=new_elves_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            local leaders = wesnoth.units.find_on_map { side = 6, role = \"elf_leader\" }"
        print "            local leader_type = leaders[1] and tostring(leaders[1].type) or \"\""
        print "            local side6_units = wesnoth.units.find_on_map { side = 6 }"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION winter_elves_raid scenario=" scenario_id " year=\" .. tostring(wml.variables[\"wf_vars.year\"] or \"\") .. \" leader_type=\" .. leader_type .. \" side6_units=\" .. tostring(#side6_units))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=new_dwarves_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            local leaders = wesnoth.units.find_on_map { side = 6, role = \"dwarf_leader\" }"
        print "            local leader_type = leaders[1] and tostring(leaders[1].type) or \"\""
        print "            local side6_units = wesnoth.units.find_on_map { side = 6 }"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION winter_dwarves_raid scenario=" scenario_id " year=\" .. tostring(wml.variables[\"wf_vars.year\"] or \"\") .. \" leader_type=\" .. leader_type .. \" side6_units=\" .. tostring(#side6_units))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=ruin_projects"
        print "    first_time_only=no"
        print "    [if]"
        print "        [have_location]"
        print "            x=$wf_automation.winter_ruin_x"
        print "            y=$wf_automation.winter_ruin_y"
        print "            terrain=Rb"
        print "        [/have_location]"
        print "        [then]"
        print "            [lua]"
        print "                code=<<"
        print "                    wesnoth.log(\"warning\", \"WF_AUTOMATION winter_ruin_castle scenario=" scenario_id " year=\" .. tostring(wml.variables[\"wf_vars.year\"] or \"\") .. \" x=\" .. tostring(wml.variables[\"wf_automation.winter_ruin_x\"] or \"\") .. \" y=\" .. tostring(wml.variables[\"wf_automation.winter_ruin_y\"] or \"\"))"
        print "                >>"
        print "            [/lua]"
        print "        [/then]"
        print "    [/if]"
        print "[/event]"
      }
      if (scenario_id == "Spring_of_Raindrops") {
        print ""
        print "[event]"
        print "    name=start"
        print "    [lua]"
        print "        code=<<"
        print "            local side1 = wesnoth.sides[1]"
        print "            local village_gold = side1 and tostring(side1.village_gold or \"\") or \"\""
        print "            local village_support = side1 and tostring(side1.village_support or \"\") or \"\""
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION spring_state scenario=" scenario_id " year=\" .. tostring(wml.variables[\"wf_vars.year\"] or \"\") .. \" economy=\" .. tostring(wml.variables[\"wf_vars.economy\"] or \"\") .. \" village_gold=\" .. village_gold .. \" village_support=\" .. village_support)"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=new_orc_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            local leaders = wesnoth.units.find_on_map { side = 5, canrecruit = true }"
        print "            local leader_type = leaders[1] and tostring(leaders[1].type) or \"\""
        print "            local side5_units = wesnoth.units.find_on_map { side = 5 }"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION spring_orc_raid scenario=" scenario_id " leader_type=\" .. leader_type .. \" side5_units=\" .. tostring(#side5_units))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=new_undead_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            local leaders = wesnoth.units.find_on_map { side = 7, canrecruit = true }"
        print "            local leader_type = leaders[1] and tostring(leaders[1].type) or \"\""
        print "            local side7_units = wesnoth.units.find_on_map { side = 7 }"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION spring_undead_raid scenario=" scenario_id " leader_type=\" .. leader_type .. \" side7_units=\" .. tostring(#side7_units))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=die"
        print "    first_time_only=no"
        print "    [filter]"
        print "        id=wf_automation_spring_drown"
        print "    [/filter]"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION spring_drowning scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
      }
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
      if (scenario_id == "Summer_of_Dreams" && force_summer_outlaw_raid == "1") {
        print ""
        print "[event]"
        print "    name=start"
        print "    [set_variable]"
        print "        name=relations.outlaws"
        print "        value=100"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=quota.outlaws"
        print "        value=1"
        print "    [/set_variable]"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_force_outlaw_raid scenario=" scenario_id " relations_outlaws=\" .. tostring(wml.variables[\"relations.outlaws\"] or \"\") .. \" quota_outlaws=\" .. tostring(wml.variables[\"quota.outlaws\"] or \"\"))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=new_outlaws_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_outlaw_raid scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
      }
      if (scenario_id == "Summer_of_Dreams" && force_summer_bandit_raid == "1") {
        print ""
        print "[event]"
        print "    name=start"
        print "    [set_variable]"
        print "        name=relations.bandits"
        print "        value=100"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=quota.bandits"
        print "        value=1"
        print "    [/set_variable]"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_force_bandit_raid scenario=" scenario_id " relations_bandits=\" .. tostring(wml.variables[\"relations.bandits\"] or \"\") .. \" quota_bandits=\" .. tostring(wml.variables[\"quota.bandits\"] or \"\"))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=new_bandits_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_bandit_raid scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
      }
      if (scenario_id == "Summer_of_Dreams" && force_summer_orc_raid == "1") {
        print ""
        print "[event]"
        print "    name=start"
        print "    [set_variable]"
        print "        name=relations.orc_raids"
        print "        value=100"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=quota.orc_raids"
        print "        value=1"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=quota.orc_enemy_choice"
        print "        value=orc"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=relations.undead_raids"
        print "        value=0"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=quota.undead_raids"
        print "        value=0"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=quota.undead_enemy_choice"
        print "        value=skip"
        print "    [/set_variable]"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_force_orc_raid scenario=" scenario_id " relations_orc_raids=\" .. tostring(wml.variables[\"relations.orc_raids\"] or \"\") .. \" quota_orc_raids=\" .. tostring(wml.variables[\"quota.orc_raids\"] or \"\") .. \" quota_orc_enemy_choice=\" .. tostring(wml.variables[\"quota.orc_enemy_choice\"] or \"\"))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=new_orc_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_orc_raid scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
      }
      if (scenario_id == "Summer_of_Dreams" && force_summer_undead_raid == "1") {
        print ""
        print "[event]"
        print "    name=start"
        print "    [set_variable]"
        print "        name=relations.undead_raids"
        print "        value=100"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=quota.undead_raids"
        print "        value=1"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=quota.undead_enemy_choice"
        print "        value=undead"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=relations.orc_raids"
        print "        value=0"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=quota.orc_raids"
        print "        value=0"
        print "    [/set_variable]"
        print "    [set_variable]"
        print "        name=quota.orc_enemy_choice"
        print "        value=skip"
        print "    [/set_variable]"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_force_undead_raid scenario=" scenario_id " relations_undead_raids=\" .. tostring(wml.variables[\"relations.undead_raids\"] or \"\") .. \" quota_undead_raids=\" .. tostring(wml.variables[\"quota.undead_raids\"] or \"\") .. \" quota_undead_enemy_choice=\" .. tostring(wml.variables[\"quota.undead_enemy_choice\"] or \"\"))"
        print "        >>"
        print "    [/lua]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=side 7 turn end"
        print "    first_time_only=yes"
        print "    [fire_event]"
        print "        name=new_undead_raid"
        print "    [/fire_event]"
        print "    [unhide_unit]"
        print "    [/unhide_unit]"
        print "[/event]"
        print ""
        print "[event]"
        print "    name=new_undead_raid"
        print "    first_time_only=no"
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_undead_raid scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
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
      if (scenario_id == "Summer_of_Dreams" && force_summer_calamity_type != "") {
        print "    [lua]"
        print "        code=<<"
        print "            if tostring(wml.variables[\"turn_number\"]) == \"1\" then"
        print "                local calamity_type = tostring(wml.variables[\"wf_automation.calamity_type\"] or \"\")"
        print "                local units = wesnoth.units.find_on_map { side = 8 }"
        print "                wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_state scenario=" scenario_id " type=\" .. calamity_type .. \" side8_units=\" .. tostring(#units))"
        print "            end"
        print "        >>"
        print "    [/lua]"
        if (force_summer_calamity_sighting == "1" && (force_summer_calamity_type == "lich" || force_summer_calamity_type == "orcs" || force_summer_calamity_type == "drakes" || force_summer_calamity_type == "dwarves" || force_summer_calamity_type == "loyalists" || force_summer_calamity_type == "elves")) {
          print "    [if]"
          print "        [and]"
          print "            [variable]"
          print "                name=turn_number"
          print "                numerical_equals=1"
          print "            [/variable]"
          print "            [have_unit]"
          print "                id=Hero"
          print "            [/have_unit]"
          print "            [have_unit]"
          print "                side=8"
          print "            [/have_unit]"
          print "        [/and]"
          print "        [then]"
          print "            [store_unit]"
          print "                [filter]"
          print "                    id=Hero"
          print "                [/filter]"
          print "                variable=wf_automation.hero_sighted"
          print "            [/store_unit]"
          print "            [store_unit]"
          print "                [filter]"
          print "                    side=8"
          print "                [/filter]"
          print "                variable=wf_automation.calamity_spot"
          print "            [/store_unit]"
          print "            [fire_event]"
          if (force_summer_calamity_type == "lich") {
            print "                name=calamity_lich_sighted"
          }
          if (force_summer_calamity_type == "orcs") {
            print "                name=calamity_orcs_sighted"
          }
          if (force_summer_calamity_type == "drakes") {
            print "                name=calamity_drakes_sighted"
          }
          if (force_summer_calamity_type == "dwarves") {
            print "                name=calamity_dwarves_sighted"
          }
          if (force_summer_calamity_type == "loyalists") {
            print "                name=calamity_loyalists_sighted"
          }
          if (force_summer_calamity_type == "elves") {
            print "                name=calamity_elves_sighted"
          }
          print "                [primary_unit]"
          print "                    x,y=$wf_automation.calamity_spot[0].x,$wf_automation.calamity_spot[0].y"
          print "                [/primary_unit]"
          print "                [secondary_unit]"
          print "                    x,y=$wf_automation.hero_sighted.x,$wf_automation.hero_sighted.y"
          print "                [/secondary_unit]"
          print "            [/fire_event]"
          print "            [clear_variable]"
          print "                name=wf_automation.hero_sighted,wf_automation.calamity_spot"
          print "            [/clear_variable]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_summer_loyalist_camp == "1" && force_summer_calamity_type == "loyalists") {
          print "    [if]"
          print "        [and]"
          print "            [variable]"
          print "                name=turn_number"
          print "                numerical_equals=1"
          print "            [/variable]"
          print "            [have_unit]"
          print "                side=8"
          print "                role=evil_loyalist"
          print "                canrecruit=yes"
          print "            [/have_unit]"
          print "        [/and]"
          print "        [then]"
          print "            [store_unit]"
          print "                [filter]"
          print "                    side=8"
          print "                    role=evil_loyalist"
          print "                    canrecruit=yes"
          print "                [/filter]"
          print "                variable=wf_automation.loyalist_leader"
          print "            [/store_unit]"
          print "            [set_variable]"
          print "                name=wf_automation.loyalist_target_x"
          print "                value=$wf_automation.loyalist_leader.goto_x"
          print "            [/set_variable]"
          print "            [set_variable]"
          print "                name=wf_automation.loyalist_target_y"
          print "                value=$wf_automation.loyalist_leader.goto_y"
          print "            [/set_variable]"
          print "            [if]"
          print "                [have_unit]"
          print "                    side=8"
          print "                    role=evil_loyalist"
          print "                    canrecruit=yes"
          print "                    x=$wf_automation.loyalist_target_x"
          print "                    y=$wf_automation.loyalist_target_y"
          print "                [/have_unit]"
          print "                [then]"
          print "                    [fire_event]"
          print "                        name=side 8 turn"
          print "                    [/fire_event]"
          print "                [/then]"
          print "                [else]"
          print "                    [move_unit]"
          print "                        side=8"
          print "                        role=evil_loyalist"
          print "                        canrecruit=yes"
          print "                        to_x=$wf_automation.loyalist_target_x"
          print "                        to_y=$wf_automation.loyalist_target_y"
          print "                    [/move_unit]"
          print "                [/else]"
          print "            [/if]"
          print "            [fire_event]"
          print "                name=moveto"
          print "                [primary_unit]"
          print "                    x,y=$wf_automation.loyalist_target_x,$wf_automation.loyalist_target_y"
          print "                [/primary_unit]"
          print "            [/fire_event]"
          print "            [if]"
          print "                [have_location]"
          print "                    x=$wf_automation.loyalist_target_x"
          print "                    y=$wf_automation.loyalist_target_y"
          print "                    terrain=Ker"
          print "                [/have_location]"
          print "                [then]"
          print "                    [lua]"
          print "                        code=<<"
          print "                            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_loyalist_camp scenario=" scenario_id " x=\" .. tostring(wml.variables[\"wf_automation.loyalist_target_x\"] or \"\") .. \" y=\" .. tostring(wml.variables[\"wf_automation.loyalist_target_y\"] or \"\"))"
          print "                        >>"
          print "                    [/lua]"
          print "                [/then]"
          print "            [/if]"
          if (force_summer_loyalist_ditch_keep == "1") {
            print "            [gold]"
            print "                side=8"
            print "                amount=-99999"
            print "            [/gold]"
          }
          print "            [clear_variable]"
          print "                name=wf_automation.loyalist_leader,wf_automation.loyalist_target_x,wf_automation.loyalist_target_y"
          print "            [/clear_variable]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_summer_saurian_keep == "1" && force_summer_calamity_type == "saurians") {
          print "    [if]"
          print "        [and]"
          print "            [variable]"
          print "                name=turn_number"
          print "                numerical_equals=1"
          print "            [/variable]"
          print "            [have_unit]"
          print "                side=8"
          print "                role=saurian_leader"
          print "                canrecruit=yes"
          print "            [/have_unit]"
          print "        [/and]"
          print "        [then]"
          print "            [store_unit]"
          print "                [filter]"
          print "                    side=8"
          print "                    role=saurian_leader"
          print "                    canrecruit=yes"
          print "                [/filter]"
          print "                variable=wf_automation.saurian_leader"
          print "            [/store_unit]"
          print "            [set_variable]"
          print "                name=wf_automation.saurian_target_x"
          print "                value=$wf_automation.saurian_leader.goto_x"
          print "            [/set_variable]"
          print "            [set_variable]"
          print "                name=wf_automation.saurian_target_y"
          print "                value=$wf_automation.saurian_leader.goto_y"
          print "            [/set_variable]"
          print "            [if]"
          print "                [have_unit]"
          print "                    side=8"
          print "                    role=saurian_leader"
          print "                    canrecruit=yes"
          print "                    x=$wf_automation.saurian_target_x"
          print "                    y=$wf_automation.saurian_target_y"
          print "                [/have_unit]"
          print "                [then]"
          print "                    [fire_event]"
          print "                        name=side 8 turn"
          print "                    [/fire_event]"
          print "                [/then]"
          print "                [else]"
          print "                    [move_unit]"
          print "                        side=8"
          print "                        role=saurian_leader"
          print "                        canrecruit=yes"
          print "                        to_x=$wf_automation.saurian_target_x"
          print "                        to_y=$wf_automation.saurian_target_y"
          print "                    [/move_unit]"
          print "                [/else]"
          print "            [/if]"
          print "            [fire_event]"
          print "                name=moveto"
          print "                [primary_unit]"
          print "                    x,y=$wf_automation.saurian_target_x,$wf_automation.saurian_target_y"
          print "                [/primary_unit]"
          print "            [/fire_event]"
          print "            [if]"
          print "                [have_location]"
          print "                    x=$wf_automation.saurian_target_x"
          print "                    y=$wf_automation.saurian_target_y"
          print "                    terrain=Khs"
          print "                [/have_location]"
          print "                [then]"
          print "                    [lua]"
          print "                        code=<<"
          print "                            wesnoth.log(\"warning\", \"WF_AUTOMATION summer_saurian_keep scenario=" scenario_id " x=\" .. tostring(wml.variables[\"wf_automation.saurian_target_x\"] or \"\") .. \" y=\" .. tostring(wml.variables[\"wf_automation.saurian_target_y\"] or \"\"))"
          print "                        >>"
          print "                    [/lua]"
          print "                [/then]"
          print "            [/if]"
          print "            [clear_variable]"
          print "                name=wf_automation.saurian_leader,wf_automation.saurian_target_x,wf_automation.saurian_target_y"
          print "            [/clear_variable]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_summer_gryphon_nest == "1" && force_summer_calamity_type == "gryphons") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [lua]"
          print "                code=<<"
          print "                    local king = wesnoth.units.find_on_map { side = 8, role = \"gryphon_king\" }[1]"
          print "                    if king then"
          print "                        local nest_status = \"\""
          print "                        if king.status then"
          print "                            nest_status = tostring(king.status.nest or \"\")"
          print "                        end"
          print "                        wesnoth.log(\"warning\", \"WF_AUTOMATION summer_gryphon_nest scenario=" scenario_id " x=\" .. tostring(king.x or \"\") .. \" y=\" .. tostring(king.y or \"\") .. \" nest=\" .. nest_status)"
          print "                    end"
          print "                >>"
          print "            [/lua]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_summer_calamity_type == "yetis") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [lua]"
          print "                code=<<"
          print "                    local leader = wesnoth.units.find_on_map { side = 8, role = \"yeti_leader\" }[1]"
          print "                    local buddy = wesnoth.units.find_on_map { side = 8, role = \"yeti_buddy\" }[1]"
          print "                    if leader and buddy then"
          print "                        wesnoth.log(\"warning\", \"WF_AUTOMATION summer_yetis scenario=" scenario_id " leader_x=\" .. tostring(leader.x or \"\") .. \" leader_y=\" .. tostring(leader.y or \"\") .. \" buddy_x=\" .. tostring(buddy.x or \"\") .. \" buddy_y=\" .. tostring(buddy.y or \"\"))"
          print "                    end"
          print "                >>"
          print "            [/lua]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_summer_calamity_kill == "1" && (force_summer_calamity_type == "lich" || force_summer_calamity_type == "orcs" || force_summer_calamity_type == "drakes" || force_summer_calamity_type == "dwarves")) {
          print "    [if]"
          print "        [and]"
          print "            [variable]"
          print "                name=turn_number"
          print "                numerical_equals=1"
          print "            [/variable]"
          print "            [have_unit]"
          print "                id=Hero"
          print "            [/have_unit]"
          print "            [have_unit]"
          print "                side=8"
          if (force_summer_calamity_type == "lich") {
            print "                role=lich"
          }
          if (force_summer_calamity_type == "orcs") {
            print "                role=orc_calamity_leader"
          }
          if (force_summer_calamity_type == "drakes") {
            print "                role=drake_leader"
          }
          if (force_summer_calamity_type == "dwarves") {
            print "                role=dwarf_calamity_leader"
          }
          print "            [/have_unit]"
          print "        [/and]"
          print "        [then]"
          print "            [store_unit]"
          print "                [filter]"
          print "                    id=Hero"
          print "                [/filter]"
          print "                variable=wf_automation.hero_kill"
          print "            [/store_unit]"
          print "            [store_unit]"
          print "                [filter]"
          print "                    side=8"
          if (force_summer_calamity_type == "lich") {
            print "                    role=lich"
          }
          if (force_summer_calamity_type == "orcs") {
            print "                    role=orc_calamity_leader"
          }
          if (force_summer_calamity_type == "drakes") {
            print "                    role=drake_leader"
          }
          if (force_summer_calamity_type == "dwarves") {
            print "                    role=dwarf_calamity_leader"
          }
          print "                [/filter]"
          print "                variable=wf_automation.calamity_target"
          print "            [/store_unit]"
          print "            [fire_event]"
          print "                name=last breath"
          print "                [primary_unit]"
          print "                    x,y=$wf_automation.calamity_target[0].x,$wf_automation.calamity_target[0].y"
          print "                [/primary_unit]"
          print "                [secondary_unit]"
          print "                    x,y=$wf_automation.hero_kill.x,$wf_automation.hero_kill.y"
          print "                [/secondary_unit]"
          print "            [/fire_event]"
          print "            [fire_event]"
          print "                name=die"
          print "                [primary_unit]"
          print "                    x,y=$wf_automation.calamity_target[0].x,$wf_automation.calamity_target[0].y"
          print "                [/primary_unit]"
          print "                [secondary_unit]"
          print "                    x,y=$wf_automation.hero_kill.x,$wf_automation.hero_kill.y"
          print "                [/secondary_unit]"
          print "            [/fire_event]"
          print "            [kill]"
          print "                id=$wf_automation.calamity_target[0].id"
          print "                animate=no"
          print "                fire_event=no"
          print "            [/kill]"
          print "            [lua]"
          print "                code=<<"
          if (force_summer_calamity_type == "lich") {
            print "                    wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_kill scenario=" scenario_id " type=lich role=lich\")"
          }
          if (force_summer_calamity_type == "orcs") {
            print "                    wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_kill scenario=" scenario_id " type=orcs role=orc_calamity_leader\")"
          }
          if (force_summer_calamity_type == "drakes") {
            print "                    wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_kill scenario=" scenario_id " type=drakes role=drake_leader\")"
          }
          if (force_summer_calamity_type == "dwarves") {
            print "                    wesnoth.log(\"warning\", \"WF_AUTOMATION summer_calamity_kill scenario=" scenario_id " type=dwarves role=dwarf_calamity_leader\")"
          }
          print "                >>"
          print "            [/lua]"
          print "            [clear_variable]"
          print "                name=wf_automation.hero_kill,wf_automation.calamity_target"
          print "            [/clear_variable]"
          print "        [/then]"
          print "    [/if]"
        }
      }
      if (scenario_id == "Autumn_of_Gold") {
        print "    [lua]"
        print "        code=<<"
        print "            if tostring(wml.variables[\"turn_number\"]) == \"1\" then"
        print "                local units = wesnoth.units.find_on_map { side = 8 }"
        print "                local nest_units = 0"
        print "                for _, unit in ipairs(units) do"
        print "                    if unit.status and unit.status.nest then"
        print "                        nest_units = nest_units + 1"
        print "                    end"
        print "                end"
        print "                local lich_present = wesnoth.units.find_on_map { side = 8, role = \"lich\" }[1] and \"yes\" or \"no\""
        print "                wesnoth.log(\"warning\", \"WF_AUTOMATION autumn_carryover scenario=" scenario_id " year=\" .. tostring(wml.variables[\"wf_vars.year\"] or \"\") .. \" side8_units=\" .. tostring(#units) .. \" nest_units=\" .. tostring(nest_units) .. \" lich_present=\" .. lich_present)"
        print "            end"
        print "        >>"
        print "    [/lua]"
        if (force_autumn_elf_keep == "1") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [fire_event]"
          print "                name=new_elves_raid"
          print "            [/fire_event]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_autumn_dwarf_keep == "1") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [fire_event]"
          print "                name=new_dwarves_raid"
          print "            [/fire_event]"
          print "        [/then]"
          print "    [/if]"
        }
      }
      if (scenario_id == "Winter_of_Storms") {
        if (force_winter_undead_raid == "1") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [fire_event]"
          print "                name=new_undead_raid"
          print "            [/fire_event]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_winter_elf_raid == "1") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [fire_event]"
          print "                name=new_elves_raid"
          print "            [/fire_event]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_winter_dwarf_raid == "1") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [fire_event]"
          print "                name=new_dwarves_raid"
          print "            [/fire_event]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_winter_ruin_castle == "1") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [store_unit]"
          print "                [filter]"
          print "                    id=Hero"
          print "                [/filter]"
          print "                variable=wf_automation.winter_ruin_target"
          print "            [/store_unit]"
          print "            [set_variable]"
          print "                name=wf_automation.winter_ruin_x"
          print "                value=$wf_automation.winter_ruin_target.x"
          print "            [/set_variable]"
          print "            [set_variable]"
          print "                name=wf_automation.winter_ruin_y"
          print "                value=$wf_automation.winter_ruin_target.y"
          print "            [/set_variable]"
          print "            [terrain]"
          print "                x,y=$wf_automation.winter_ruin_x,$wf_automation.winter_ruin_y"
          print "                terrain=Kvr"
          print "            [/terrain]"
          print "            [lua]"
          print "                code=<<"
          print "                    wesnoth.log(\"warning\", \"WF_AUTOMATION winter_ruin_seed scenario=" scenario_id " year=\" .. tostring(wml.variables[\"wf_vars.year\"] or \"\") .. \" x=\" .. tostring(wml.variables[\"wf_automation.winter_ruin_x\"] or \"\") .. \" y=\" .. tostring(wml.variables[\"wf_automation.winter_ruin_y\"] or \"\"))"
          print "                >>"
          print "            [/lua]"
          print "            [terrain]"
          print "                x,y=$wf_automation.winter_ruin_x,$wf_automation.winter_ruin_y"
          print "                terrain=Rb"
          print "            [/terrain]"
          print "            [lua]"
          print "                code=<<"
          print "                    wesnoth.log(\"warning\", \"WF_AUTOMATION winter_ruin_castle scenario=" scenario_id " year=\" .. tostring(wml.variables[\"wf_vars.year\"] or \"\") .. \" x=\" .. tostring(wml.variables[\"wf_automation.winter_ruin_x\"] or \"\") .. \" y=\" .. tostring(wml.variables[\"wf_automation.winter_ruin_y\"] or \"\"))"
          print "                >>"
          print "            [/lua]"
          print "            [clear_variable]"
          print "                name=wf_automation.winter_ruin_target"
          print "            [/clear_variable]"
          print "        [/then]"
          print "    [/if]"
        }
      }
      if (scenario_id == "Spring_of_Raindrops") {
        if (force_spring_orc_raid == "1") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [fire_event]"
          print "                name=new_orc_raid"
          print "            [/fire_event]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_spring_undead_raid == "1") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [fire_event]"
          print "                name=new_undead_raid"
          print "            [/fire_event]"
          print "        [/then]"
          print "    [/if]"
        }
        if (force_spring_drowning == "1") {
          print "    [if]"
          print "        [variable]"
          print "            name=turn_number"
          print "            numerical_equals=1"
          print "        [/variable]"
          print "        [then]"
          print "            [kill]"
          print "                id=wf_automation_spring_drown"
          print "                animate=no"
          print "                fire_event=no"
          print "            [/kill]"
          print "            [store_locations]"
          print "                variable=wf_automation.spring_drown_hex"
          print "                terrain=Wo*"
          print "                [filter_adjacent_location]"
          print "                    terrain=Wo*"
          print "                    count=6"
          print "                [/filter_adjacent_location]"
          print "            [/store_locations]"
          print "            [if]"
          print "                [have_location]"
          print "                    x=$wf_automation.spring_drown_hex[0].x"
          print "                    y=$wf_automation.spring_drown_hex[0].y"
          print "                    terrain=Wo*"
          print "                [/have_location]"
          print "                [then]"
          print "                    [unit]"
          print "                        id=wf_automation_spring_drown"
          print "                        side=1"
          print "                        type=Peasant"
          print "                        x,y=$wf_automation.spring_drown_hex[0].x,$wf_automation.spring_drown_hex[0].y"
          print "                        hitpoints=1"
          print "                        moves=0"
          print "                        upkeep=loyal"
          print "                        [modifications]"
          print "                            [object]"
          print "                                [effect]"
          print "                                    apply_to=movement_costs"
          print "                                    replace=yes"
          print "                                    [movement_costs]"
          print "                                        deep_water=99"
          print "                                    [/movement_costs]"
          print "                                [/effect]"
          print "                            [/object]"
          print "                        [/modifications]"
          print "                    [/unit]"
          print "                    [store_unit]"
          print "                        [filter]"
          print "                            id=wf_automation_spring_drown"
          print "                        [/filter]"
          print "                        variable=wf_automation.spring_drown_unit"
          print "                    [/store_unit]"
          print "                    [lua]"
          print "                        code=<<"
          print "                            wesnoth.log(\"warning\", \"WF_AUTOMATION spring_drowning_seed scenario=" scenario_id " x=\" .. tostring(wml.variables[\"wf_automation.spring_drown_unit.x\"] or \"\") .. \" y=\" .. tostring(wml.variables[\"wf_automation.spring_drown_unit.y\"] or \"\"))"
          print "                        >>"
          print "                    [/lua]"
          print "                    [harm_unit]"
          print "                        [filter]"
          print "                            id=wf_automation_spring_drown"
          print "                        [/filter]"
          print "                        amount=4"
          print "                        kill=yes"
          print "                        animate=no"
          print "                    [/harm_unit]"
          print "                    [if]"
          print "                        [not]"
          print "                            [have_unit]"
          print "                                id=wf_automation_spring_drown"
          print "                            [/have_unit]"
          print "                        [/not]"
          print "                        [then]"
          print "                            [lua]"
          print "                                code=<<"
          print "                                    wesnoth.log(\"warning\", \"WF_AUTOMATION spring_drowning scenario=" scenario_id "\")"
          print "                                >>"
          print "                            [/lua]"
          print "                        [/then]"
          print "                    [/if]"
          print "                    [clear_variable]"
          print "                        name=wf_automation.spring_drown_unit"
          print "                    [/clear_variable]"
          print "                [/then]"
          print "            [/if]"
          print "            [clear_variable]"
          print "                name=wf_automation.spring_drown_hex"
          print "            [/clear_variable]"
          print "        [/then]"
          print "    [/if]"
        }
      }
      if (scenario_id == "A_New_Beginning" && force_season_end == "1") {
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION event=force_season_end scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        print "    [fire_event]"
        print "        name=wf_time_over"
        print "    [/fire_event]"
      } else if (scenario_id == "Summer_of_Dreams" && force_summer_end == "1") {
        print "    [if]"
        print "        [variable]"
        print "            name=wf_vars.year"
        print "            numerical_equals=0"
        print "        [/variable]"
        print "        [then]"
        print "            [lua]"
        print "                code=<<"
        print "                    wesnoth.log(\"warning\", \"WF_AUTOMATION event=force_season_end scenario=" scenario_id "\")"
        print "                >>"
        print "            [/lua]"
        print "            [fire_event]"
        print "                name=wf_time_over"
        print "            [/fire_event]"
        print "        [/then]"
        print "        [else]"
        if (force_second_summer_end_turn != "0") {
          print "            [if]"
          print "                [variable]"
          print "                    name=turn_number"
          print "                    greater_than_equal_to=" force_second_summer_end_turn
          print "                [/variable]"
          print "                [then]"
          print "                    [lua]"
          print "                        code=<<"
          print "                            wesnoth.log(\"warning\", \"WF_AUTOMATION event=force_second_summer_end scenario=" scenario_id " turn=\" .. tostring(wml.variables[\"turn_number\"]))"
          print "                        >>"
          print "                    [/lua]"
          print "                    [fire_event]"
          print "                        name=wf_time_over"
          print "                    [/fire_event]"
          print "                [/then]"
          print "                [else]"
          print "                    [end_turn]"
          print "                    [/end_turn]"
          print "                [/else]"
          print "            [/if]"
        } else {
          print "            [end_turn]"
          print "            [/end_turn]"
        }
        print "        [/else]"
        print "    [/if]"
      } else if (scenario_id == "Autumn_of_Gold" && force_autumn_end == "1") {
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION event=force_season_end scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        print "    [fire_event]"
        print "        name=wf_time_over"
        print "    [/fire_event]"
      } else if (scenario_id == "Winter_of_Storms" && force_winter_end == "1") {
        print "    [lua]"
        print "        code=<<"
        print "            wesnoth.log(\"warning\", \"WF_AUTOMATION event=force_season_end scenario=" scenario_id "\")"
        print "        >>"
        print "    [/lua]"
        print "    [fire_event]"
        print "        name=wf_time_over"
        print "    [/fire_event]"
      } else if (scenario_id == "Spring_of_Raindrops" && force_spring_end == "1") {
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
    inject_debug_overlay "$addon_dir/scenarios/autumn_of_gold.cfg" "Autumn_of_Gold"
    inject_debug_overlay "$addon_dir/scenarios/winter_of_storms.cfg" "Winter_of_Storms"
    inject_debug_overlay "$addon_dir/scenarios/spring_of_raindrops.cfg" "Spring_of_Raindrops"
    apply_runtime_overrides "$addon_dir"
  fi
}

apply_runtime_overrides() {
  local addon_dir=$1
  local enemies_path="$addon_dir/utils/enemies.cfg"
  local winter_path="$addon_dir/scenarios/winter_of_storms.cfg"

  if [[ "$WF_FORCE_AUTUMN_ELF_KEEP" == "1" ]]; then
    perl -0pi -e 's/(#define NEW_ELVES_RAIDS LIMIT.*?\{VARIABLE REPEAT_b 0\}\n)\s*\{RANDOM_VAR build_castle \(yes,yes,no\)\}/$1        {VARIABLE build_castle yes}/s' "$enemies_path"
  fi

  if [[ "$WF_FORCE_AUTUMN_DWARF_KEEP" == "1" ]]; then
    perl -0pi -e 's/(#define NEW_DWARVES_RAIDS LIMIT.*?\{VARIABLE REPEAT_b 0\}\n)\s*\{RANDOM_VAR build_castle \(yes,yes,no\)\}/$1        {VARIABLE build_castle yes}/s' "$enemies_path"
  fi

  if [[ "$WF_FORCE_WINTER_RUIN_CASTLE" == "1" ]]; then
    perl -0pi -e 's/\{RANDOM_VAR do_collapse \(no,yes\)\}/{VARIABLE do_collapse yes}/g' "$winter_path"
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

normalize_line_value() {
  printf '%s\n' "$1" | sed '/^$/d' | tail -n 1
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

wait_for_log_text_with_return() {
  local log_path=$1
  local needle=$2
  local timeout=${3:-60}
  local deadline=$((SECONDS + timeout))

  while (( SECONDS < deadline )); do
    if [[ -f "$log_path" ]] && rg -Fq "$needle" "$log_path"; then
      return 0
    fi
    send_key return
    sleep 2
  done

  echo "Timed out waiting for log text while advancing dialog: $needle" >&2
  return 1
}

wait_for_scenario_entry() {
  local log_path=$1
  local from_scenario=$2
  local to_scenario=$3
  local label=$4
  local timeout=${5:-60}

  wait_for_log_text_with_return "$log_path" "WF_AUTOMATION event=wf_victory scenario=$from_scenario next=$to_scenario" "$timeout"
  note_progress "${label}_victory_marker status=0"
  wait_for_log_text_with_return "$log_path" "WF_AUTOMATION overlay_ready scenario=$to_scenario" "$timeout"
  note_progress "${label}_overlay_ready status=0"
  wait_for_log_text_with_return "$log_path" "WF_AUTOMATION side1_turn_refresh scenario=$to_scenario turn=1" "$timeout"
  note_progress "${label}_turn1 status=0"
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

extract_summer_calamity_units() {
  local log_path=$1
  local scenario_id=$2

  rg -o "WF_AUTOMATION summer_calamity_state scenario=${scenario_id} type=[^ ]+ side8_units=[0-9]+" "$log_path" 2>/dev/null \
    | sed 's/.*side8_units=//' \
    | tail -n 1
}

extract_summer_calamity_aftermath_gold() {
  local log_path=$1
  local scenario_id=$2
  local calamity_type=$3

  rg -o "WF_AUTOMATION summer_calamity_aftermath scenario=${scenario_id} type=${calamity_type} side1_gold=[0-9]+" "$log_path" 2>/dev/null \
    | sed 's/.*side1_gold=//' \
    | tail -n 1
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
  local artifact_prefix=$4
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

  capture_and_ocr "${artifact_prefix}-${initial_turn}"

  while (( SECONDS < deadline )); do
    max_turn=$(extract_log_turn "$log_path" "$scenario_id")
    if [[ -n "$max_turn" ]]; then
      use_log=1
    fi

    if (( use_log == 1 )); then
      if [[ -n "$max_turn" ]]; then
        if (( max_turn > seen_turn )); then
          for turn in $(seq $((seen_turn + 1)) "$max_turn"); do
            capture_and_ocr "${artifact_prefix}-${turn}"
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
          capture_and_ocr "${artifact_prefix}-${current_turn}"
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
  note_progress "simulator_ready"

  local container
  container=$(find_container)
  sync_addon "$container"
  note_progress "addon_synced"

  local before_log
  before_log=$(latest_log "$container")

  local -a launch_args
  launch_args=(--strict-lua --campaign="$WF_ADDON_NAME" --campaign-difficulty="$WF_DIFFICULTY" --campaign-skip-story)
  if [[ "$WF_NOCACHE" == "1" ]]; then
    launch_args=(--nocache "${launch_args[@]}")
  fi

  xcrun simctl terminate "$SIMULATOR_UDID" "$WESNOTH_BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl launch "$SIMULATOR_UDID" "$WESNOTH_BUNDLE_ID" "${launch_args[@]}"
  note_progress "app_launched"

  local run_log_name
  run_log_name=$(wait_for_new_log "$container" "$before_log")
  run_log_name=$(normalize_line_value "$run_log_name")
  local log_path="$container/Library/Application Support/wesnoth.org/iWesnoth/logs/$run_log_name"
  note_progress "log_detected $run_log_name"

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
  note_progress "startup_complete"

  local run_status=0
  advance_turns "$log_path" "$WF_END_TURNS" "$WF_START_SCENARIO" "turn" || run_status=$?
  note_progress "start_scenario_complete status=$run_status"

  if [[ "$WF_WAIT_FOR_SCENARIO_END" == "1" ]]; then
    wait_for_scenario_entry "$log_path" "$WF_START_SCENARIO" "$WF_NEXT_SCENARIO" "next_scenario" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
    if [[ "$WF_WAIT_FOR_SUMMER_OUTLAW_RAID" == "1" ]]; then
      wait_for_log_text "$log_path" "WF_AUTOMATION summer_outlaw_raid scenario=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_outlaw_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_BANDIT_RAID" == "1" ]]; then
      wait_for_log_text "$log_path" "WF_AUTOMATION summer_bandit_raid scenario=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_bandit_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_ORC_RAID" == "1" ]]; then
      wait_for_log_text "$log_path" "WF_AUTOMATION summer_orc_raid scenario=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_orc_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_UNDEAD_RAID" == "1" ]]; then
      wait_for_log_text "$log_path" "WF_AUTOMATION summer_undead_raid scenario=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_undead_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_CALAMITY" == "1" ]]; then
      wait_for_log_text "$log_path" "WF_AUTOMATION summer_calamity_state scenario=$WF_NEXT_SCENARIO type=$WF_FORCE_SUMMER_CALAMITY_TYPE" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_calamity status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_GRYPHON_NEST" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION summer_gryphon_nest scenario=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_gryphon_nest status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_YETIS" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION summer_yetis scenario=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_yetis status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_CALAMITY_SIGHTING" == "1" ]]; then
      wait_for_log_text "$log_path" "WF_AUTOMATION summer_calamity_sighting scenario=$WF_NEXT_SCENARIO type=$WF_FORCE_SUMMER_CALAMITY_TYPE" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_calamity_sighting status=$run_status"
      send_key return "$WF_CALAMITY_DIALOG_ADVANCES"
      sleep 2
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_LOYALIST_CAMP" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION summer_loyalist_camp scenario=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_loyalist_camp status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_LOYALIST_DITCH_KEEP" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION summer_loyalist_ditch_keep scenario=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_loyalist_ditch_keep status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_SAURIAN_KEEP" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION summer_saurian_keep scenario=$WF_NEXT_SCENARIO" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_saurian_keep status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_CALAMITY_KILL" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION summer_calamity_kill scenario=$WF_NEXT_SCENARIO type=$WF_FORCE_SUMMER_CALAMITY_TYPE" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_calamity_kill status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_CALAMITY_AFTERMATH" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION summer_calamity_aftermath scenario=$WF_NEXT_SCENARIO type=$WF_FORCE_SUMMER_CALAMITY_TYPE" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "next_scenario_calamity_aftermath status=$run_status"
    fi
    if (( WF_NEXT_END_TURNS > 0 )); then
      advance_turns "$log_path" "$WF_NEXT_END_TURNS" "$WF_NEXT_SCENARIO" "${WF_NEXT_SCENARIO}-turn" || run_status=$?
      note_progress "next_scenario_complete status=$run_status"
    fi
    if [[ -n "$WF_CHAIN_SCENARIO_2" ]]; then
      wait_for_scenario_entry "$log_path" "$WF_NEXT_SCENARIO" "$WF_CHAIN_SCENARIO_2" "chain_scenario_2" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
    fi
    if [[ "$WF_WAIT_FOR_AUTUMN_CARRYOVER" == "1" ]]; then
      wait_for_log_text "$log_path" "WF_AUTOMATION autumn_carryover scenario=Autumn_of_Gold" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "autumn_carryover status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_AUTUMN_ELF_KEEP" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION autumn_elf_keep scenario=Autumn_of_Gold" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "autumn_elf_keep status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_AUTUMN_DWARF_KEEP" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION autumn_dwarf_keep scenario=Autumn_of_Gold" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "autumn_dwarf_keep status=$run_status"
    fi
    if [[ -n "$WF_CHAIN_SCENARIO_3" ]]; then
      wait_for_scenario_entry "$log_path" "$WF_CHAIN_SCENARIO_2" "$WF_CHAIN_SCENARIO_3" "chain_scenario_3" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
    fi
    if [[ "$WF_WAIT_FOR_WINTER_STATE" == "1" ]]; then
      wait_for_log_text "$log_path" "WF_AUTOMATION winter_state scenario=Winter_of_Storms" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "winter_state status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_WINTER_UNDEAD_RAID" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION winter_undead_raid scenario=Winter_of_Storms" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "winter_undead_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_WINTER_ELF_RAID" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION winter_elves_raid scenario=Winter_of_Storms" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "winter_elves_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_WINTER_DWARF_RAID" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION winter_dwarves_raid scenario=Winter_of_Storms" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "winter_dwarves_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_WINTER_RUIN_CASTLE" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION winter_ruin_castle scenario=Winter_of_Storms" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "winter_ruin_castle status=$run_status"
    fi
    if [[ -n "$WF_CHAIN_SCENARIO_4" ]]; then
      wait_for_scenario_entry "$log_path" "$WF_CHAIN_SCENARIO_3" "$WF_CHAIN_SCENARIO_4" "chain_scenario_4" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
    fi
    if [[ "$WF_WAIT_FOR_SPRING_STATE" == "1" ]]; then
      wait_for_log_text "$log_path" "WF_AUTOMATION spring_state scenario=$WF_CHAIN_SCENARIO_4" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "spring_state status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SPRING_ORC_RAID" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION spring_orc_raid scenario=$WF_CHAIN_SCENARIO_4" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "spring_orc_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SPRING_UNDEAD_RAID" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION spring_undead_raid scenario=$WF_CHAIN_SCENARIO_4" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "spring_undead_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SPRING_DROWNING" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION spring_drowning scenario=$WF_CHAIN_SCENARIO_4" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "spring_drowning status=$run_status"
    fi
    if [[ -n "$WF_CHAIN_SCENARIO_5" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION event=wf_victory scenario=$WF_CHAIN_SCENARIO_4 next=$WF_CHAIN_SCENARIO_5" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "chain_scenario_5_victory_marker status=$run_status"
      if [[ "$WF_CHAIN_SCENARIO_5" != "$WF_NEXT_SCENARIO" ]]; then
        wait_for_log_text_with_return "$log_path" "WF_AUTOMATION overlay_ready scenario=$WF_CHAIN_SCENARIO_5" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
        note_progress "chain_scenario_5_overlay_ready status=$run_status"
        wait_for_log_text_with_return "$log_path" "WF_AUTOMATION side1_turn_refresh scenario=$WF_CHAIN_SCENARIO_5 turn=1" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
        note_progress "chain_scenario_5_turn1 status=$run_status"
      fi
    fi
    if [[ "$WF_WAIT_FOR_SECOND_SUMMER_STATE" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION summer_state scenario=$WF_CHAIN_SCENARIO_5 year=1" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "second_summer_state status=$run_status"
    fi
    if (( WF_CHAIN_5_END_TURNS > 0 )); then
      advance_turns "$log_path" "$WF_CHAIN_5_END_TURNS" "$WF_CHAIN_SCENARIO_5" "${WF_CHAIN_SCENARIO_5}-cycle2-turn" || run_status=$?
      note_progress "chain_scenario_5_complete status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SECOND_AUTUMN_CARRYOVER" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION autumn_carryover scenario=$WF_CHAIN_SCENARIO_6 year=1" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "second_autumn_carryover status=$run_status"
    fi
    if (( WF_CHAIN_6_END_TURNS > 0 )); then
      advance_turns "$log_path" "$WF_CHAIN_6_END_TURNS" "$WF_CHAIN_SCENARIO_6" "${WF_CHAIN_SCENARIO_6}-cycle2-turn" || run_status=$?
      note_progress "chain_scenario_6_complete status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SECOND_WINTER_STATE" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION winter_state scenario=$WF_CHAIN_SCENARIO_7 year=1" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "second_winter_state status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SECOND_WINTER_UNDEAD_RAID" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION winter_undead_raid scenario=$WF_CHAIN_SCENARIO_7 year=1" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "second_winter_undead_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SECOND_WINTER_ELF_RAID" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION winter_elves_raid scenario=$WF_CHAIN_SCENARIO_7 year=1" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "second_winter_elves_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SECOND_WINTER_DWARF_RAID" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION winter_dwarves_raid scenario=$WF_CHAIN_SCENARIO_7 year=1" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "second_winter_dwarves_raid status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SECOND_WINTER_RUIN_CASTLE" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION winter_ruin_castle scenario=$WF_CHAIN_SCENARIO_7 year=1" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "second_winter_ruin_castle status=$run_status"
    fi
    if [[ "$WF_WAIT_FOR_SECOND_SPRING_STATE" == "1" ]]; then
      wait_for_log_text_with_return "$log_path" "WF_AUTOMATION spring_state scenario=$WF_CHAIN_SCENARIO_8 year=2" "$WF_SCENARIO_END_TIMEOUT" || run_status=$?
      note_progress "second_spring_state status=$run_status"
    fi
    if (( WF_CHAIN_7_END_TURNS > 0 )); then
      advance_turns "$log_path" "$WF_CHAIN_7_END_TURNS" "$WF_CHAIN_SCENARIO_7" "${WF_CHAIN_SCENARIO_7}-cycle2-turn" || run_status=$?
      note_progress "chain_scenario_7_complete status=$run_status"
    fi
  fi

  local after_log
  after_log=$(latest_log "$container")
  after_log=$(normalize_line_value "$after_log")
  log_path="$container/Library/Application Support/wesnoth.org/iWesnoth/logs/$after_log"
  cp "$log_path" "$ARTIFACT_DIR/$after_log"
  error_check "$log_path" || run_status=$?
  note_progress "final_log_copied status=$run_status"

  local reached_turn
  reached_turn=$(extract_log_turn "$log_path" "$WF_START_SCENARIO")
  if [[ -z "$reached_turn" && -f "$ARTIFACT_DIR/turn-scan.txt" ]]; then
    reached_turn=$(extract_turn_number "$ARTIFACT_DIR/turn-scan.txt")
  fi
  local next_reached_turn=""
  local autumn_reached_turn=""
  local winter_reached_turn=""
  local spring_reached_turn=""
  local chain_5_reached_turn=""
  local chain_6_reached_turn=""
  local chain_7_reached_turn=""
  local chain_8_reached_turn=""
  local summer_outlaw_raid_seen=""
  local summer_bandit_raid_seen=""
  local summer_orc_raid_seen=""
  local summer_undead_raid_seen=""
  local summer_calamity_seen=""
  local summer_calamity_side8_units=""
  local summer_gryphon_nest_seen=""
  local summer_yetis_seen=""
  local summer_calamity_sighting_seen=""
  local summer_loyalist_camp_seen=""
  local summer_loyalist_ditch_keep_seen=""
  local summer_saurian_keep_seen=""
  local autumn_carryover_seen=""
  local second_autumn_carryover_seen=""
  local autumn_elf_keep_seen=""
  local autumn_dwarf_keep_seen=""
  local winter_state_seen=""
  local second_winter_state_seen=""
  local winter_undead_raid_seen=""
  local winter_elf_raid_seen=""
  local winter_dwarf_raid_seen=""
  local winter_ruin_castle_seen=""
  local second_winter_undead_raid_seen=""
  local second_winter_elf_raid_seen=""
  local second_winter_dwarf_raid_seen=""
  local second_winter_ruin_castle_seen=""
  local spring_state_seen=""
  local second_spring_state_seen=""
  local spring_orc_raid_seen=""
  local spring_undead_raid_seen=""
  local spring_drowning_seen=""
  local second_summer_state_seen=""
  local summer_calamity_kill_seen=""
  local summer_calamity_aftermath_seen=""
  local summer_calamity_aftermath_side1_gold=""
  if [[ "$WF_WAIT_FOR_SCENARIO_END" == "1" ]]; then
    next_reached_turn=$(extract_log_turn "$log_path" "$WF_NEXT_SCENARIO")
    if [[ -n "$WF_CHAIN_SCENARIO_2" ]]; then
      autumn_reached_turn=$(extract_log_turn "$log_path" "$WF_CHAIN_SCENARIO_2")
    fi
    if [[ -n "$WF_CHAIN_SCENARIO_3" ]]; then
      winter_reached_turn=$(extract_log_turn "$log_path" "$WF_CHAIN_SCENARIO_3")
    fi
    if [[ -n "$WF_CHAIN_SCENARIO_4" ]]; then
      spring_reached_turn=$(extract_log_turn "$log_path" "$WF_CHAIN_SCENARIO_4")
    fi
    if [[ -n "$WF_CHAIN_SCENARIO_5" ]]; then
      chain_5_reached_turn=$(extract_log_turn "$log_path" "$WF_CHAIN_SCENARIO_5")
    fi
    if [[ -n "$WF_CHAIN_SCENARIO_6" ]]; then
      chain_6_reached_turn=$(extract_log_turn "$log_path" "$WF_CHAIN_SCENARIO_6")
    fi
    if [[ -n "$WF_CHAIN_SCENARIO_7" ]]; then
      chain_7_reached_turn=$(extract_log_turn "$log_path" "$WF_CHAIN_SCENARIO_7")
    fi
    if [[ -n "$WF_CHAIN_SCENARIO_8" ]]; then
      chain_8_reached_turn=$(extract_log_turn "$log_path" "$WF_CHAIN_SCENARIO_8")
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_OUTLAW_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_outlaw_raid scenario=$WF_NEXT_SCENARIO" "$log_path"; then
        summer_outlaw_raid_seen=yes
      else
        summer_outlaw_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_BANDIT_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_bandit_raid scenario=$WF_NEXT_SCENARIO" "$log_path"; then
        summer_bandit_raid_seen=yes
      else
        summer_bandit_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_ORC_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_orc_raid scenario=$WF_NEXT_SCENARIO" "$log_path"; then
        summer_orc_raid_seen=yes
      else
        summer_orc_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_UNDEAD_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_undead_raid scenario=$WF_NEXT_SCENARIO" "$log_path"; then
        summer_undead_raid_seen=yes
      else
        summer_undead_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_CALAMITY" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_calamity_state scenario=$WF_NEXT_SCENARIO type=$WF_FORCE_SUMMER_CALAMITY_TYPE" "$log_path"; then
        summer_calamity_seen=yes
      else
        summer_calamity_seen=no
      fi
      summer_calamity_side8_units=$(extract_summer_calamity_units "$log_path" "$WF_NEXT_SCENARIO")
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_GRYPHON_NEST" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_gryphon_nest scenario=$WF_NEXT_SCENARIO" "$log_path"; then
        summer_gryphon_nest_seen=yes
      else
        summer_gryphon_nest_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_YETIS" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_yetis scenario=$WF_NEXT_SCENARIO" "$log_path"; then
        summer_yetis_seen=yes
      else
        summer_yetis_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_CALAMITY_SIGHTING" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_calamity_sighting scenario=$WF_NEXT_SCENARIO type=$WF_FORCE_SUMMER_CALAMITY_TYPE" "$log_path"; then
        summer_calamity_sighting_seen=yes
      else
        summer_calamity_sighting_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_LOYALIST_CAMP" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_loyalist_camp scenario=$WF_NEXT_SCENARIO" "$log_path"; then
        summer_loyalist_camp_seen=yes
      else
        summer_loyalist_camp_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_LOYALIST_DITCH_KEEP" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_loyalist_ditch_keep scenario=$WF_NEXT_SCENARIO" "$log_path"; then
        summer_loyalist_ditch_keep_seen=yes
      else
        summer_loyalist_ditch_keep_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_SAURIAN_KEEP" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_saurian_keep scenario=$WF_NEXT_SCENARIO" "$log_path"; then
        summer_saurian_keep_seen=yes
      else
        summer_saurian_keep_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_AUTUMN_CARRYOVER" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION autumn_carryover scenario=Autumn_of_Gold" "$log_path"; then
        autumn_carryover_seen=yes
      else
        autumn_carryover_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SECOND_AUTUMN_CARRYOVER" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION autumn_carryover scenario=$WF_CHAIN_SCENARIO_6 year=1" "$log_path"; then
        second_autumn_carryover_seen=yes
      else
        second_autumn_carryover_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_AUTUMN_ELF_KEEP" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION autumn_elf_keep scenario=Autumn_of_Gold" "$log_path"; then
        autumn_elf_keep_seen=yes
      else
        autumn_elf_keep_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_AUTUMN_DWARF_KEEP" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION autumn_dwarf_keep scenario=Autumn_of_Gold" "$log_path"; then
        autumn_dwarf_keep_seen=yes
      else
        autumn_dwarf_keep_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_WINTER_STATE" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION winter_state scenario=Winter_of_Storms" "$log_path"; then
        winter_state_seen=yes
      else
        winter_state_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SECOND_WINTER_STATE" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION winter_state scenario=$WF_CHAIN_SCENARIO_7 year=1" "$log_path"; then
        second_winter_state_seen=yes
      else
        second_winter_state_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SECOND_WINTER_UNDEAD_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION winter_undead_raid scenario=$WF_CHAIN_SCENARIO_7 year=1" "$log_path"; then
        second_winter_undead_raid_seen=yes
      else
        second_winter_undead_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SECOND_WINTER_ELF_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION winter_elves_raid scenario=$WF_CHAIN_SCENARIO_7 year=1" "$log_path"; then
        second_winter_elf_raid_seen=yes
      else
        second_winter_elf_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SECOND_WINTER_DWARF_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION winter_dwarves_raid scenario=$WF_CHAIN_SCENARIO_7 year=1" "$log_path"; then
        second_winter_dwarf_raid_seen=yes
      else
        second_winter_dwarf_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SECOND_WINTER_RUIN_CASTLE" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION winter_ruin_castle scenario=$WF_CHAIN_SCENARIO_7 year=1" "$log_path"; then
        second_winter_ruin_castle_seen=yes
      else
        second_winter_ruin_castle_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_WINTER_UNDEAD_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION winter_undead_raid scenario=Winter_of_Storms" "$log_path"; then
        winter_undead_raid_seen=yes
      else
        winter_undead_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_WINTER_ELF_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION winter_elves_raid scenario=Winter_of_Storms" "$log_path"; then
        winter_elf_raid_seen=yes
      else
        winter_elf_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_WINTER_DWARF_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION winter_dwarves_raid scenario=Winter_of_Storms" "$log_path"; then
        winter_dwarf_raid_seen=yes
      else
        winter_dwarf_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_WINTER_RUIN_CASTLE" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION winter_ruin_castle scenario=Winter_of_Storms" "$log_path"; then
        winter_ruin_castle_seen=yes
      else
        winter_ruin_castle_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SPRING_STATE" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION spring_state scenario=$WF_CHAIN_SCENARIO_4" "$log_path"; then
        spring_state_seen=yes
      else
        spring_state_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SECOND_SPRING_STATE" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION spring_state scenario=$WF_CHAIN_SCENARIO_8 year=2" "$log_path"; then
        second_spring_state_seen=yes
      else
        second_spring_state_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SPRING_ORC_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION spring_orc_raid scenario=$WF_CHAIN_SCENARIO_4" "$log_path"; then
        spring_orc_raid_seen=yes
      else
        spring_orc_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SPRING_UNDEAD_RAID" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION spring_undead_raid scenario=$WF_CHAIN_SCENARIO_4" "$log_path"; then
        spring_undead_raid_seen=yes
      else
        spring_undead_raid_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SPRING_DROWNING" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION spring_drowning scenario=$WF_CHAIN_SCENARIO_4" "$log_path"; then
        spring_drowning_seen=yes
      else
        spring_drowning_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SECOND_SUMMER_STATE" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_state scenario=$WF_CHAIN_SCENARIO_5 year=1" "$log_path"; then
        second_summer_state_seen=yes
      else
        second_summer_state_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_CALAMITY_KILL" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_calamity_kill scenario=$WF_NEXT_SCENARIO type=$WF_FORCE_SUMMER_CALAMITY_TYPE" "$log_path"; then
        summer_calamity_kill_seen=yes
      else
        summer_calamity_kill_seen=no
      fi
    fi
    if [[ "$WF_WAIT_FOR_SUMMER_CALAMITY_AFTERMATH" == "1" ]]; then
      if rg -Fq "WF_AUTOMATION summer_calamity_aftermath scenario=$WF_NEXT_SCENARIO type=$WF_FORCE_SUMMER_CALAMITY_TYPE" "$log_path"; then
        summer_calamity_aftermath_seen=yes
      else
        summer_calamity_aftermath_seen=no
      fi
      summer_calamity_aftermath_side1_gold=$(extract_summer_calamity_aftermath_gold "$log_path" "$WF_NEXT_SCENARIO" "$WF_FORCE_SUMMER_CALAMITY_TYPE")
    fi
  fi

  {
    echo "artifact_dir=$ARTIFACT_DIR"
    echo "container=$container"
    echo "before_log=$before_log"
    echo "after_log=$after_log"
    echo "turns=$WF_END_TURNS"
    echo "reached_turn=$reached_turn"
    echo "next_turns=$WF_NEXT_END_TURNS"
    echo "next_reached_turn=$next_reached_turn"
    echo "autumn_reached_turn=$autumn_reached_turn"
    echo "winter_reached_turn=$winter_reached_turn"
    echo "spring_reached_turn=$spring_reached_turn"
    echo "chain_5_reached_turn=$chain_5_reached_turn"
    echo "chain_6_reached_turn=$chain_6_reached_turn"
    echo "chain_7_reached_turn=$chain_7_reached_turn"
    echo "chain_8_reached_turn=$chain_8_reached_turn"
    echo "summer_outlaw_raid_seen=$summer_outlaw_raid_seen"
    echo "summer_bandit_raid_seen=$summer_bandit_raid_seen"
    echo "summer_orc_raid_seen=$summer_orc_raid_seen"
    echo "summer_undead_raid_seen=$summer_undead_raid_seen"
    echo "summer_calamity_type=$WF_FORCE_SUMMER_CALAMITY_TYPE"
    echo "summer_calamity_seen=$summer_calamity_seen"
    echo "summer_calamity_side8_units=$summer_calamity_side8_units"
    echo "summer_gryphon_nest_seen=$summer_gryphon_nest_seen"
    echo "summer_yetis_seen=$summer_yetis_seen"
    echo "summer_calamity_sighting_seen=$summer_calamity_sighting_seen"
    echo "summer_loyalist_camp_seen=$summer_loyalist_camp_seen"
    echo "summer_loyalist_ditch_keep_seen=$summer_loyalist_ditch_keep_seen"
    echo "summer_saurian_keep_seen=$summer_saurian_keep_seen"
    echo "autumn_carryover_seen=$autumn_carryover_seen"
    echo "second_autumn_carryover_seen=$second_autumn_carryover_seen"
    echo "autumn_elf_keep_seen=$autumn_elf_keep_seen"
    echo "autumn_dwarf_keep_seen=$autumn_dwarf_keep_seen"
    echo "winter_state_seen=$winter_state_seen"
    echo "second_winter_state_seen=$second_winter_state_seen"
    echo "winter_undead_raid_seen=$winter_undead_raid_seen"
    echo "winter_elf_raid_seen=$winter_elf_raid_seen"
    echo "winter_dwarf_raid_seen=$winter_dwarf_raid_seen"
    echo "winter_ruin_castle_seen=$winter_ruin_castle_seen"
    echo "second_winter_undead_raid_seen=$second_winter_undead_raid_seen"
    echo "second_winter_elf_raid_seen=$second_winter_elf_raid_seen"
    echo "second_winter_dwarf_raid_seen=$second_winter_dwarf_raid_seen"
    echo "second_winter_ruin_castle_seen=$second_winter_ruin_castle_seen"
    echo "spring_state_seen=$spring_state_seen"
    echo "second_spring_state_seen=$second_spring_state_seen"
    echo "spring_orc_raid_seen=$spring_orc_raid_seen"
    echo "spring_undead_raid_seen=$spring_undead_raid_seen"
    echo "spring_drowning_seen=$spring_drowning_seen"
    echo "second_summer_state_seen=$second_summer_state_seen"
    echo "summer_calamity_kill_seen=$summer_calamity_kill_seen"
    echo "summer_calamity_aftermath_seen=$summer_calamity_aftermath_seen"
    echo "summer_calamity_aftermath_side1_gold=$summer_calamity_aftermath_side1_gold"
    echo "run_status=$run_status"
  } | tee "$ARTIFACT_DIR/summary.txt"
  note_progress "summary_written status=$run_status"

  return "$run_status"
}

main "$@"
