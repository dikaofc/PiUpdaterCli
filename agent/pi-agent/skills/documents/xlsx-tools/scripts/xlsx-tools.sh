#!/usr/bin/env bash
# XLSX Tools — read, write, and inspect Excel .xlsx workbooks and metadata
# Source: https://openpyxl.readthedocs.io/
set -euo pipefail

SCRIPT_NAME="xlsx-tools.sh"

usage() {
  cat <<EOF
Usage: ${SCRIPT_NAME} sheets <file.xlsx>
       ${SCRIPT_NAME} read <file.xlsx> [--sheet NAME] [--rows N]
       ${SCRIPT_NAME} create <out.xlsx> <sheet-name> <csv-file>
       ${SCRIPT_NAME} info <file.xlsx>
Read and create Excel workbooks. Conversion from CSV uses python3's
built-in csv + zipfile (no external libs); rich reads optionally use
openpyxl when available.

Options:
  --sheet NAME  sheet to read (default: first)
  --rows N      max rows to show (default: all)
  --sheet C     sheet name for create (default Sheet1)
  -h | --help   show this help
EOF
}

[ $# -lt 1 ] && { usage; exit 1; }

CMD=""
ARGS=()
SHEET=""
ROWS=""
CREATE_SHEET="Sheet1"
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help) usage; exit 0;;
    sheets|read|create|info) CMD="$1"; shift;;
    --sheet) SHEET="$2"; shift 2;;
    --rows) ROWS="$2"; shift 2;;
    -*) echo "unknown flag: $1" >&2; exit 2;;
    *) ARGS+=("$1"); shift;;
  esac
done

[ -z "$CMD" ] && { usage; exit 1; }

python3 - "$CMD" "${ARGS[@]}" "$SHEET" "$ROWS" "$CREATE_SHEET" <<'PYEOF'
import sys, zipfile, re, csv, os

cmd = sys.argv[1]
rest = sys.argv[2:]
sheet_arg = sys.argv[-3]
rows_arg = sys.argv[-2]
create_sheet = sys.argv[-1]

try:
    import openpyxl
    HAS_OPENPYXL = True
except ImportError:
    HAS_OPENPYXL = False

def sheet_names(path):
    with zipfile.ZipFile(path) as z:
        wb = z.read("xl/workbook.xml").decode("utf-8")
        names = re.findall(r'<sheet[^>]*name="([^"]*)"', wb)
        rels = None
        # map sheetIds to targets if needed
        return names or ["Sheet1"]

def read_sheet_zip(path, sheet_name, max_rows):
    sst = []
    with zipfile.ZipFile(path) as z:
        wbxml = z.read("xl/workbook.xml").decode("utf-8")
        relsxml = z.read("xl/_rels/workbook.xml.rels").decode("utf-8") if "xl/_rels/workbook.xml.rels" in z.namelist() else ""
        # find target file for sheet
        m = re.search(rf'<sheet[^>]*name="{re.escape(sheet_name)}"[^>]*r:id="([^"]+)"', wbxml)
        if not m:
            for s in re.finditer(r'<sheet[^>]*name="([^"]*)"[^>]*r:id="([^"]+)"', wbxml):
                if s.group(1) == sheet_name:
                    m = s
        if not m:
            print(f"sheet not found: {sheet_name}  (available: {', '.join(sheet_names(path))})", file=sys.stderr)
            sys.exit(1)
        rid = m.group(1)
        tm = re.search(rf'Id="{rid}"[^>]*Target="([^"]+)"', relsxml) or re.search(rf'Target="([^"]+)"[^>]*Id="{rid}"', relsxml)
        target = "xl/" + tm.group(1).lstrip("/") if tm else "xl/worksheets/sheet1.xml"
        xml = z.read(target).decode("utf-8")
        # shared strings table
        if "xl/sharedStrings.xml" in z.namelist():
            sstxml = z.read("xl/sharedStrings.xml").decode("utf-8")
            sst = ["".join(re.findall(r"<t[^>]*>([^<]*)</t>", si)) for si in re.split(r"</si>", sstxml)]
    # parse inline/shared strings simply: rows/cells from <c ...> with <v> or <t> for inline strings
    rows_out = []
    row_re = re.compile(r"<row[^>]*r=\"(\d+)\"[^>]*>(.*?)</row>", re.S)
    cell_re = re.compile(r"<c[^>]*r=\"([A-Z]+)\d+\"([^>]*)>(?:<v>([^<]*)</v>|<is><t[^>]*>([^<]*)</t></is>|<t[^>]*>([^<]*)</t>)", re.S)
    for rm in row_re.finditer(xml):
        r = int(rm.group(1))
        cells = {}
        for cm in cell_re.finditer(rm.group(2)):
            col = cm.group(1)
            attrs = cm.group(2) or ""
            val = cm.group(3)
            if val is None:
                val = cm.group(4) or cm.group(5) or ""
            elif 't="s"' in attrs:
                try:
                    val = sst[int(val)] if val and int(val) < len(sst) else val
                except (ValueError, IndexError):
                    pass
            cells[col] = val
        if cells:
            rows_out.append((r, cells))
    return rows_out

if cmd == "sheets":
    path = rest[0]
    f = regex_str(rest[0]) if False else rest[0]
    print("\n".join(sheet_names(path)))

elif cmd == "info":
    path = rest[0]
    if not os.path.exists(path):
        print(f"not found: {path}", file=sys.stderr); sys.exit(1)
    if HAS_OPENPYXL:
        wb = openpyxl.load_workbook(path, read_only=True)
        print(f"file: {path}")
        for ws in wb.worksheets:
            print(f"  sheet '{ws.title}': {ws.max_row} rows x {ws.max_column} cols")
    else:
        with zipfile.ZipFile(path) as z:
            wbxml = z.read("xl/workbook.xml").decode("utf-8")
            ns = re.findall(r'<sheet[^>]*name="([^"]*)"', wbxml)
            print(f"file: {path}")
            print(f"  sheets: {', '.join(ns) or 'none'}  (openpyxl not installed; install for detailed info)")

elif cmd == "read":
    path = rest[0]
    if not os.path.exists(path):
        print(f"not found: {path}", file=sys.stderr); sys.exit(1)
    max_rows = int(rows_arg) if rows_arg else 0
    if HAS_OPENPYXL:
        wb = openpyxl.load_workbook(path, read_only=True, data_only=True)
        ws = wb[sheet_arg] if sheet_arg else wb.worksheets[0]
        for i, row in enumerate(ws.iter_rows(values_only=True), 1):
            if max_rows and i > max_rows:
                print(f"... (showing {max_rows} of {ws.max_row} rows)")
                break
            print("\t".join("" if v is None else str(v) for v in row))
    else:
        names = sheet_names(path)
        name = sheet_arg or names[0]
        data = read_sheet_zip(path, name, max_rows)
        if not data:
            print(f"no cells parsed from {name} (openpyxl recommended: pip install openpyxl)", file=sys.stderr)
        for _, cells in data:
            vals = [cells.get(c, "") for c in sorted(cells)]
            print("\t".join(vals))

elif cmd == "create":
    out_xlsx, sheet_csv = rest[0], rest[1] if len(rest) > 1 else None
    if not sheet_csv:
        print("usage: xlsx-tools.sh create <out.xlsx> <csv>", file=sys.stderr); sys.exit(2)
    if not os.path.exists(sheet_csv):
        print(f"csv not found: {sheet_csv}", file=sys.stderr); sys.exit(1)
    rows = list(csv.reader(open(sheet_csv, newline="", encoding="utf-8", errors="replace")))
    import html
    def esc(v):
        return html.escape(str(v), quote=False)
    sst = []
    used = set()
    def sst_idx(v):
        if v not in used:
            sst.append(v); used.add(v)
        return sst.index(v)
    # Simple shared-strings workbook
    sheet_xml = ['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>']
    cols = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for r, row in enumerate(rows, 1):
        sheet_xml.append(f'<row r="{r}">')
        for c, v in enumerate(row, 1):
            col = cols[c-1] if c <= 26 else cols[c//26-1] + cols[c%26-1]
            if v == "":
                continue
            sheet_xml.append(f'<c r="{col}{r}" t="s"><v>{sst_idx(v)}</v></c>')
        sheet_xml.append('</row>')
    sheet_xml.append('</sheetData></worksheet>')
    ss = ['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
          f'<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="{sum(len(r) for r in rows)}" uniqueCount="{len(sst)}">']
    for v in sst:
        ss.append(f'<si><t>{esc(v)}</t></si>')
    ss.append('</sst>')
    wbxml = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
             '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
             'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
             f'<sheets><sheet name="{esc(create_sheet)}" sheetId="1" r:id="rId1"/></sheets></workbook>')
    wbrels = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
              '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
              '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/></Relationships>')
    ct = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
          '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
          '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
          '<Default Extension="xml" ContentType="application/xml"/>'
          '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
          '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
          '<Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>'
          '</Types>')
    with zipfile.ZipFile(out_xlsx, "w") as z:
        z.writestr("[Content_Types].xml", ct)
        z.writestr("_rels/.rels", '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/></Relationships>')
        z.writestr("xl/workbook.xml", wbxml)
        z.writestr("xl/_rels/workbook.xml.rels", wbrels)
        z.writestr("xl/worksheets/sheet1.xml", "".join(sheet_xml))
        z.writestr("xl/sharedStrings.xml", "".join(ss))
    print(f"created {out_xlsx} ({len(rows)} rows)")

PYEOF