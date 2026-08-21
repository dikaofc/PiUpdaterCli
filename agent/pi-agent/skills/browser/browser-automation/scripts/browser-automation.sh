#!/usr/bin/env bash
# Browser Automation — drive a headless browser to screenshot, scrape, fill forms
# Source: https://playwright.dev/
set -euo pipefail

SCRIPT_NAME="browser-automation.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} screenshot <url> <out.png> [--width W] [--height H] [--full]
       ${SCRIPT_NAME} scrape <url> [--selector CSS] [--json]
       ${SCRIPT_NAME} fill <url> <selector> <value> [--submit CSS] [--out <file.png>]
       ${SCRIPT_NAME} pdf <url> <out.pdf>
Drive a headless browser (Chromium-based) to screenshot, scrape,
and automate forms. Uses node + playwright when available; falls
back to a python3 stdlib fetch for simple scraping.

Options:
  --width W     viewport width (default 1280)
  --height H    viewport height (default 800)
  --full        full-page screenshot
  --selector S  CSS selector to extract text of
  --json        output as JSON
  --submit S    CSS selector to click after filling
  --out FILE    output file
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
WIDTH=1280
HEIGHT=800
FULL=0
SEL=""
JSON=0
SUBMIT=""
OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    screenshot|scrape|fill|pdf) CMD="$1"; shift;;
    --width) WIDTH="$2"; shift 2;;
    --height) HEIGHT="$2"; shift 2;;
    --full) FULL=1; shift;;
    --selector) SEL="$2"; shift 2;;
    --json) JSON=1; shift;;
    --submit) SUBMIT="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

have_playwright() {
  node -e "require('playwright')" >/dev/null 2>&1 || node -e "require('puppeteer')" >/dev/null 2>&1
}

case "$CMD" in
  screenshot)
    URL="${ARGS[0]:?usage: screenshot <url> <out.png>}"
    OUT_ARG="${ARGS[1]:-shot.png}"
    if have_playwright; then use_pw=1; else use_pw=0; fi
    if [ "$use_pw" = "1" ]; then
      PW_URL="$URL" PW_OUT="$OUT_ARG" PW_W="$WIDTH" PW_H="$HEIGHT" PW_FULL="$FULL" node - <<'JS'
const { chromium } = require('playwright') || require('puppeteer');
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: +process.env.PW_W, height: +process.env.PW_H } });
  await page.goto(process.env.PW_URL, { waitUntil: 'networkidle', timeout: 30000 }).catch(() => {});
  const full = process.env.PW_FULL === '1';
  await page.screenshot({ path: process.env.PW_OUT, fullPage: full });
  await browser.close();
  console.log('saved ' + process.env.PW_OUT);
})().catch(e => { console.error(String(e)); process.exit(1); });
JS
    else
      echo "playwright not installed (npm i playwright && npx playwright install chromium)" >&2
      echo "falling back to a simple fetch + note (no browser engine)" >&2
      curl -sSL --max-time 30 -A "Mozilla/5.0" -o "$OUT_ARG" "$URL" 2>/dev/null && echo "downloaded $URL -> $OUT_ARG (HTML, not a screenshot)" || { echo "fetch failed" >&2; exit 1; }
    fi
    ;;
  scrape)
    URL="${ARGS[0]:?usage: scrape <url>}"
    if have_playwright; then
      PW_URL="$URL" PW_SEL="$SEL" PW_JSON="$JSON" node - <<'JS'
const { chromium } = require('playwright') || require('puppeteer');
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto(process.env.PW_URL, { waitUntil: 'domcontentloaded', timeout: 30000 }).catch(() => {});
  if (process.env.PW_SEL) {
    const els = await page.$$(process.env.PW_SEL);
    const texts = [];
    for (const el of els.slice(0, 50)) texts.push((await el.textContent()).trim());
    console.log(process.env.PW_JSON === '1' ? JSON.stringify(texts) : texts.join('\n'));
  } else {
    const body = await page.evaluate(() => document.body.innerText);
    console.log(body.slice(0, 50000));
  }
  await browser.close();
})().catch(e => { console.error(String(e)); process.exit(1); });
JS
    else
      echo "playwright not installed — using plain HTTP fetch (no JS rendering)" >&2
      BODY=$(curl -sSL --max-time 30 -A "Mozilla/5.0" "$URL" 2>/dev/null || { echo "fetch failed" >&2; exit 1; })
      python3 -c "
import sys, re, html
body = sys.stdin.read()
body = re.sub(r'<script.*?</script>', ' ', body, flags=re.S|re.I)
body = re.sub(r'<style.*?</style>', ' ', body, flags=re.S|re.I)
text = re.sub(r'<[^>]+>', ' ', body)
text = html.unescape(re.sub(r'\s+', ' ', text)).strip()
print(text[:50000])" <<< "$BODY"
    fi
    ;;
  fill)
    URL="${ARGS[0]:?usage: fill <url> <selector> <value>}"
    SEL_ARG="${ARGS[1]}"; VAL_ARG="${ARGS[2]}"
    if have_playwright; then
      PW_URL="$URL" PW_SEL="$SEL_ARG" PW_VAL="$VAL_ARG" PW_SUBMIT="$SUBMIT" PW_OUT="$OUT" node - <<'JS'
const { chromium } = require('playwright') || require('puppeteer');
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto(process.env.PW_URL, { waitUntil: 'domcontentloaded', timeout: 30000 }).catch(() => {});
  await page.fill(process.env.PW_SEL, process.env.PW_VAL);
  if (process.env.PW_SUBMIT) {
    await page.click(process.env.PW_SUBMIT).catch(() => {});
  }
  await page.waitForTimeout(1500);
  if (process.env.PW_OUT) {
    await page.screenshot({ path: process.env.PW_OUT, fullPage: true });
    console.log('saved ' + process.env.PW_OUT);
  } else {
    console.log('filled ' + process.env.PW_SEL + ' with ' + process.env.PW_VAL + (process.env.PW_SUBMIT ? ' and clicked ' + process.env.PW_SUBMIT : ''));
  }
  await browser.close();
})().catch(e => { console.error(String(e)); process.exit(1); });
JS
    else
      echo "playwright required for form automation (npm i playwright)" >&2
      exit 1
    fi
    ;;
  pdf)
    URL="${ARGS[0]:?usage: pdf <url> <out.pdf>}"
    OUT_ARG="${ARGS[1]:-page.pdf}"
    if have_playwright; then
      PW_URL="$URL" PW_OUT="$OUT_ARG" node - <<'JS'
const { chromium } = require('playwright') || require('puppeteer');
(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto(process.env.PW_URL, { waitUntil: 'networkidle', timeout: 30000 }).catch(() => {});
  await page.pdf({ path: process.env.PW_OUT, format: 'A4' });
  await browser.close();
  console.log('saved ' + process.env.PW_OUT);
})().catch(e => { console.error(String(e)); process.exit(1); });
JS
    else
      echo "playwright required for PDF generation (npm i playwright)" >&2
      exit 1
    fi
    ;;
esac