#!/usr/bin/env bash
# Lundy Recorder - Interactive field audio logger
# Requires: termux-api + ffmpeg
# chmod +x lundy_recorder.sh
# Run: ./lundy_recorder.sh

set -euo pipefail

TARGET_FOLDER_DEFAULT="$HOME/Recordings/Lundy"
STATE_DIR="$HOME/.lundy_recorder_state"
SEG_DIR="${STATE_DIR}/segments"
TMP_DIR="${STATE_DIR}/tmp"

mkdir -p "$STATE_DIR" "$SEG_DIR" "$TMP_DIR" "$TARGET_FOLDER_DEFAULT"

is_recording() { [[ -f "$STATE_DIR/recording.pid" ]]; }
current_segment() { cat "$STATE_DIR/current.seg" 2>/dev/null || true; }

start_segment() {
    local ts seg
    ts="$(date +%Y%m%d_%H%M%S)"
    seg="${SEG_DIR}/seg_${ts}.wav"
    termux-microphone-record -f "$seg" start >/dev/null 2>&1 || {
        echo "Failed to start recording (check Termux:API and mic permission)."
        return 1
    }
    echo "$seg" >"$STATE_DIR/current.seg"
    echo "$!" >"$STATE_DIR/recording.pid"
    echo "🎤 Recording started → $seg"
}

stop_segment() {
    if ! is_recording; then
        echo "No active recording."
        return 1
    fi
    termux-microphone-record stop >/dev/null 2>&1 || true
    rm -f "$STATE_DIR/recording.pid"
    echo "Segment finalized: $(current_segment)"
    rm -f "$STATE_DIR/current.seg"
}

finalize_recording() {
    local TARGET="${1:-$TARGET_FOLDER_DEFAULT}"
    mkdir -p "$TARGET"

    if is_recording; then
        echo "Stopping active recording..."
        stop_segment
    fi

    mapfile -t segs < <(ls -1 "$SEG_DIR"/seg_*.wav 2>/dev/null || true)
    (( ${#segs[@]} == 0 )) && { echo "No segments to finalize."; return; }

    echo "Processing ${#segs[@]} segment(s)..."
    local conv_list="$TMP_DIR/list.txt"
    rm -f "$TMP_DIR"/* "$conv_list"

    local idx=0
    for s in "${segs[@]}"; do
        idx=$((idx+1))
        conv="$TMP_DIR/seg_$(printf "%03d" "$idx")_conv.wav"
        ffmpeg -y -hide_banner -loglevel error -i "$s" \
            -ar 48000 -ac 2 -sample_fmt s32 "$conv"
        echo "file '$conv'" >>"$conv_list"
    done

    local final="$TARGET/Lundy_$(date +%Y%m%d_%H%M%S).wav"
    ffmpeg -y -hide_banner -loglevel error -f concat -safe 0 -i "$conv_list" -c copy "$final"
    echo "✅ Final file saved → $final"

    ARCHIVE="$STATE_DIR/archive_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$ARCHIVE"
    mv "$SEG_DIR"/*.wav "$ARCHIVE"/ 2>/dev/null || true
    echo "Segments archived → $ARCHIVE"
}

show_status() {
    echo
    if is_recording; then
        echo "🎙️  Status: Recording"
        echo "   File: $(current_segment)"
    else
        echo "⏹️  Status: Idle"
    fi
    echo "Segments:"
    ls -1 "$SEG_DIR"/*.wav 2>/dev/null || echo "   (none)"
    echo
}

# Interactive loop
clear
echo "=========================================="
echo "     Lundy Field Recorder - Termux"
echo "=========================================="
echo "Files saved to: $TARGET_FOLDER_DEFAULT"
echo "Commands: start | pause | resume | stop | status | exit"
echo "=========================================="

while true; do
    echo -n "> "
    read -r cmd
    case "$cmd" in
        start)
            if is_recording; then
                echo "Already recording!"
            else
                start_segment
            fi
            ;;
        pause)
            stop_segment
            ;;
        resume)
            if is_recording; then
                echo "Already recording!"
            else
                start_segment
            fi
            ;;
        stop)
            finalize_recording "$TARGET_FOLDER_DEFAULT"
            ;;
        status)
            show_status
            ;;
        exit|quit)
            if is_recording; then
                echo "⚠️  You’re still recording! Stop first (or type 'force' to exit)."
            else
                echo "Exiting recorder. Goodbye, Agent Lundy."
                break
            fi
            ;;
        force)
            echo "Force exiting..."
            termux-microphone-record stop >/dev/null 2>&1 || true
            break
            ;;
        *)
            echo "Unknown command: $cmd"
            ;;
    esac
done
