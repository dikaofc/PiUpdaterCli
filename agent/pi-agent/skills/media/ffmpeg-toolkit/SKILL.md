---
name: ffmpeg-toolkit
description: Transcode, trim, crop, inspect media; extract audio/subtitles.
license: MIT
compatibility: "POSIX shell + curl + jq. No build step."
source: https://ffmpeg.org/ffmpeg.html
metadata:
  category: media
  language: bash
  tags: [ffmpeg-toolkit]
---
# FFmpeg Toolkit

Transcode, trim, crop, inspect media; extract audio/subtitles.

See [the reference guide](references/REFERENCE.md) for full details.

## Setup

```bash
chmod +x scripts/ffmpeg-toolkit.sh
which curl jq || apt-get install -y curl jq   # debian/ubuntu
```

## Usage

```bash
./scripts/ffmpeg-toolkit.sh "<required-args>"
```

### Arguments

```
<input>            primary input for the skill
--out <file>        write result to a file instead of stdout
-h | --help         show this help
```

Invoke from pi with: `/skill:ffmpeg-toolkit <args>`
