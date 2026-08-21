#!/usr/bin/env bash
# FFmpeg Toolkit — transcode, trim, crop, inspect media; extract audio/subtitles
# Source: https://ffmpeg.org/documentation.html
set -euo pipefail

SCRIPT_NAME="ffmpeg-toolkit.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} info <file>
       ${SCRIPT_NAME} transcode <in> <out> [--crf N] [--audio] [--video-codec X]
       ${SCRIPT_NAME} trim <in> <out> <start> <duration>   # e.g. "00:01:30" "00:00:45"
       ${SCRIPT_NAME} crop <in> <out> <w>:<h>:<x>:<y>
       ${SCRIPT_NAME} audio <in> <out>                    # extract audio (mp3)
       ${SCRIPT_NAME} subtitles <in> <out.srt|ASS>        # extract subs (via ffmpeg)
       ${SCRIPT_NAME} gif <in> <out.gif> [--fps N]
Inspect, transcode, trim, crop, and extract media streams with ffmpeg.

Options:
  --crf N          quality 0-51 (lower = better, default 23)
  --audio          include audio in transcode
  --video-codec X  codec (libx264 default)
  --fps N          gif frame rate (default 15)
  -h | --help      show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
CRF=23
AUDIO=0
VCODEC="libx264"
FPS=15
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    info|transcode|trim|crop|audio|subtitles|gif) CMD="$1"; shift;;
    --crf) CRF="$2"; shift 2;;
    --audio) AUDIO=1; shift;;
    --video-codec) VCODEC="$2"; shift 2;;
    --fps) FPS="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }
command -v ffmpeg >/dev/null 2>&1 || { echo "ffmpeg not installed: pkg install ffmpeg" >&2; exit 1; }

case "$CMD" in
  info)
    F="${ARGS[0]:?usage: info <file>}"
    [ -f "$F" ] || { echo "not found: $F" >&2; exit 1; }
    ffprobe -v error -show_entries format=filename,duration,size,bit_rate -of default=noprint_wrappers=1 "$F" 2>&1
    echo ""
    echo "streams:"
    ffprobe -v error -show_entries stream=index,codec_type,codec_name,width,height,avg_frame_rate -of csv=p=0 "$F" 2>&1 | while IFS=, read -r idx type codec w h fr; do
      echo "  [$idx] $type: $codec ${w:+${w}x${h} }${fr}"
    done
    ;;
  transcode)
    IN="${ARGS[0]:?usage: transcode <in> <out>}"
    OUT_ARG="${ARGS[1]:?usage: transcode <in> <out>}"
    [ -f "$IN" ] || { echo "not found: $IN" >&2; exit 1; }
    if [ "$AUDIO" = "1" ]; then
      ffmpeg -y -i "$IN" -c:v "$VCODEC" -crf "$CRF" -c:a aac -b:a 128k "$OUT_ARG" 2>&1 | tail -3
    else
      ffmpeg -y -i "$IN" -c:v "$VCODEC" -crf "$CRF" -an "$OUT_ARG" 2>&1 | tail -3
    fi
    echo "done: $OUT_ARG"
    ;;
  trim)
    IN="${ARGS[0]:?usage: trim <in> <out> <start> <duration>}"
    OUT_ARG="${ARGS[1]}"; START="${ARGS[2]}"; DUR="${ARGS[3]}"
    [ -f "$IN" ] || { echo "not found: $IN" >&2; exit 1; }
    ffmpeg -y -i "$IN" -ss "$START" -t "$DUR" -c copy "$OUT_ARG" 2>&1 | tail -2
    echo "done: $OUT_ARG (start $START, duration $DUR)"
    ;;
  crop)
    IN="${ARGS[0]:?usage: crop <in> <out> <w>:<h>:<x>:<y>}"
    OUT_ARG="${ARGS[1]}"; GEOM="${ARGS[2]}"
    [ -f "$IN" ] || { echo "not found: $IN" >&2; exit 1; }
    ffmpeg -y -i "$IN" -vf "crop=$GEOM" -c:v "$VCODEC" -crf "$CRF" -an "$OUT_ARG" 2>&1 | tail -2
    echo "done: $OUT_ARG (crop $GEOM)"
    ;;
  audio)
    IN="${ARGS[0]:?usage: audio <in> <out>}"
    OUT_ARG="${ARGS[1]:-${IN%.*}.mp3}"
    [ -f "$IN" ] || { echo "not found: $IN" >&2; exit 1; }
    if ! ffprobe -v error -select_streams a -show_entries stream=index -of csv=p=0 "$IN" 2>/dev/null | grep -q .; then
      echo "no audio stream found in $IN" >&2
      exit 1
    fi
    ffmpeg -y -i "$IN" -vn -acodec libmp3lame -q:a 2 "$OUT_ARG" 2>&1 | tail -2
    echo "done: $OUT_ARG"
    ;;
  subtitles)
    IN="${ARGS[0]:?usage: subtitles <in> <out.srt>}"
    OUT_ARG="${ARGS[1]:-${IN%.*}.srt}"
    [ -f "$IN" ] || { echo "not found: $IN" >&2; exit 1; }
    STREAM=$(ffprobe -v error -select_streams s -show_entries stream=index:stream=codec_name -of csv=p=0 "$IN" 2>/dev/null | head -1 | cut -d, -f1)
    if [ -z "$STREAM" ]; then
      echo "no subtitle stream found" >&2; exit 1
    fi
    ffmpeg -y -i "$IN" -map "0:$STREAM" -c:s srt "$OUT_ARG" 2>&1 | tail -2
    echo "done: $OUT_ARG"
    ;;
  gif)
    IN="${ARGS[0]:?usage: gif <in> <out.gif>}"
    OUT_ARG="${ARGS[1]:-${IN%.*}.gif}"
    [ -f "$IN" ] || { echo "not found: $IN" >&2; exit 1; }
    ffmpeg -y -i "$IN" -vf "fps=$FPS,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$OUT_ARG" 2>&1 | tail -2
    echo "done: $OUT_ARG"
    ;;
esac