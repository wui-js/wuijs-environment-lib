#!/usr/bin/env python3
"""
docs-check.py — WUI/JS Documentation Check
Validates version consistency between source files and documentation
(class table in docs/README-<lang>.md, class documents in
docs/classes/<name>/<prefix>-<name>-<lang>.md).

The same script runs in every WUI/JS library; the library is detected from
its source directory (src/wui-js/<kind>/):
  main         wui-<name>         WUI<Name>
  plugins      wuiplugin-<name>   WUIPlugin<Name>
  views        wuiview-<name>     WUIView<Name>
  environment  wui-environment    WUIEnvironment (one document per platform:
               docs/classes/environment/wui-environment-<platform>-<lang>.md)

Usage:
  python docs-check.py                 → all components, English (default)
  python docs-check.py en              → all components, English
  python docs-check.py es              → all components, Spanish
  python docs-check.py en button       → single component, English
  python docs-check.py es button,modal → multiple components, Spanish
  python docs-check.py button          → single component, English (default)
"""

import sys, os, re, glob

# ── ANSI colors ───────────────────────────────────────────────────────────────
CYAN  = "\033[96m"
GREEN = "\033[92m"
RED   = "\033[91m"
RESET = "\033[0m"

# ── Paths ─────────────────────────────────────────────────────────────────────
REPO   = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DOCS   = os.path.join(REPO, "docs")
LIBS   = {
    "main":        {"prefix": "wui",       "cls": "WUI"},
    "plugins":     {"prefix": "wuiplugin", "cls": "WUIPlugin"},
    "views":       {"prefix": "wuiview",   "cls": "WUIView"},
    "environment": {"prefix": "wui",       "cls": "WUI"},
}
KIND   = next((k for k in LIBS if os.path.isdir(os.path.join(REPO, "src", "wui-js", k))), "main")
MAIN   = os.path.join(REPO, "src", "wui-js", KIND)
PREFIX = LIBS[KIND]["prefix"]
WUI_JS = os.path.join(MAIN, "wui.js")
PLATFORMS = {
    "android": ("Android", os.path.join("android", "WUIEnvironment.java")),
    "ios":     ("iOS",     os.path.join("ios", "WUIEnvironment.swift")),
    "web":     ("Web",     None),
}


def get_lib_version():
    if os.path.isfile(WUI_JS):
        for line in open(WUI_JS, encoding="utf-8"):
            m = re.search(r'const version\s*=\s*"([^"]+)"', line)
            if m:
                return m.group(1)
        return "?"
    version_path = os.path.join(REPO, "VERSION")
    return open(version_path, encoding="utf-8").read().strip() if os.path.isfile(version_path) else "?"


def comp_to_class(comp):
    if KIND == "environment":
        return "WUIEnvironment"
    return LIBS[KIND]["cls"] + comp[0].upper() + comp[1:]


def comp_heading(comp):
    if KIND == "environment":
        return f"# WUIEnvironment ({PLATFORMS[comp][0]})"
    return f"# {comp_to_class(comp)}"


def comp_file_name(comp):
    """File name stem of the sources: button → wui-button, environment platforms → wui-environment."""
    return "wui-environment" if KIND == "environment" else f"{PREFIX}-{comp}"


def comp_dir(comp):
    return os.path.join(MAIN, "web" if KIND == "environment" else comp)


def get_source_version(comp):
    if KIND == "environment" and PLATFORMS[comp][1]:
        path = os.path.join(MAIN, PLATFORMS[comp][1])
        if os.path.isfile(path):
            for line in open(path, encoding="utf-8"):
                m = re.search(r'@version\s+([0-9.]+)', line)
                if m:
                    return m.group(1)
        return None
    name = comp_file_name(comp)
    for ext in ("js", "css"):
        files = [f for f in glob.glob(os.path.join(comp_dir(comp), f"{name}-*.{ext}"))
                 if ".root." not in f]
        if files:
            m = re.search(rf"{name}-([0-9.]+)\.{ext}$", os.path.basename(files[0]))
            if m:
                return m.group(1)
    return None


def get_doc_order(doc_path):
    """Return component names in class table order."""
    if KIND == "environment":
        return list(PLATFORMS)
    order, seen = [], set()
    for line in open(doc_path, encoding="utf-8"):
        m = re.match(rf'\|\s*\[?({LIBS[KIND]["cls"]}(\w+))\]?[^|]*\|\s*`[0-9.]+`', line)
        if m:
            comp = m.group(2).lower()
            if comp not in seen:
                seen.add(comp)
                order.append(comp)
    return order


def get_class_doc_rel(comp, lang):
    """Return the class documentation path relative to docs/: button → classes/button/wui-button-en.md."""
    if KIND == "environment":
        return f"classes/environment/wui-environment-{comp}-{lang}.md"
    return f"classes/{comp}/{PREFIX}-{comp}-{lang}.md"


def get_class_doc_path(comp, lang):
    return os.path.join(DOCS, get_class_doc_rel(comp, lang))

def get_class_lines(comp, lang):
    """Return the class documentation lines, or None if the file or its # WUI<Name> heading is missing."""
    path = get_class_doc_path(comp, lang)
    if not os.path.isfile(path):
        return None
    lines = [l.rstrip("\n") for l in open(path, encoding="utf-8")]
    heading = comp_heading(comp)
    if not any(line.strip().lower() == heading.lower() for line in lines):
        return None
    return lines


def ok(text):
    return f"  [{GREEN}pass{RESET}] {text}"

def fail(text):
    return f"  [{RED}fail{RESET}] {text}"

def fail_detail(lineno, value, expected):
    return f"    {RED}line {lineno}: '{value}' (expected '{expected}'){RESET}"


def check_component(comp, lang, lines, src_ver, summary=False):
    cls = comp_to_class(comp)

    # ── 1. Class documentation ─────────────────────────────────────────────
    section_lines = get_class_lines(comp, lang)
    has_section = section_lines is not None
    doc_fails = not has_section

    # ── 2. Class table version ─────────────────────────────────────────────
    table_fails = []
    in_table = False
    for i, line in enumerate(lines):
        if re.search(r'\|\s*(Class name|Nombre Clase|Clase)\s*\|', line, re.IGNORECASE):
            in_table = True
        if not in_table:
            continue
        if in_table and line.strip() == "":
            in_table = False
            continue
        if KIND == "environment":
            m = re.match(rf'\|\s*\[?{cls}\]?\([^)]*-{comp}-{lang}\.md\)[^`]*`([0-9.]+)`', line)
        else:
            m = re.match(rf'\|\s*\[?{cls}\]?[^|]*\|\s*`([0-9.]+)`', line, re.IGNORECASE)
        if m:
            if m.group(1) != src_ver:
                table_fails.append((i + 1, m.group(1)))
            break

    # ── 3. Field version ───────────────────────────────────────────────────
    field_fails = []
    if has_section:
        offset = 0
        for i, line in enumerate(section_lines):
            m = re.match(r'\s*Versi[oó]n:\s*`([0-9.]+)`', line, re.IGNORECASE) or \
                re.match(r'\s*Version:\s*`([0-9.]+)`', line, re.IGNORECASE)
            if m and m.group(1) != src_ver:
                field_fails.append((offset + i + 1, m.group(1)))

    # ── 4. Files name version ──────────────────────────────────────────────
    file_fails = []
    if has_section:
        file_pattern = re.compile(rf'{comp_file_name(comp)}-([0-9.]+)\.(root\.css|css|js)')
        for i, line in enumerate(section_lines):
            seen_in_line = set()
            for m in file_pattern.finditer(line):
                match_str = m.group(0)
                if m.group(1) != src_ver and match_str not in seen_in_line:
                    seen_in_line.add(match_str)
                    file_fails.append((offset + i + 1, match_str))

    # ── 5/6/7: root.css vs documentation CSS variables (pre-compute) ──────────
    only_doc = only_root_v = value_fails = []
    doc_vars = doc_defaults = root_vars = {}
    if has_section:
        root_path = os.path.join(comp_dir(comp), f"{comp_file_name(comp)}-{src_ver}.root.css")
        root_vars = {}
        if os.path.isfile(root_path):
            for line in open(root_path, encoding="utf-8"):
                m = re.match(r'\s*(--wui-[a-zA-Z0-9_-]+)\s*:\s*([^;]+);', line)
                if m:
                    root_vars[m.group(1).strip()] = m.group(2).strip()

        doc_vars = set()
        for line in section_lines:
            m = re.match(r'\|\s*`(--wui-[a-zA-Z0-9_-]+)`', line)
            if m:
                doc_vars.add(m.group(1))

        doc_defaults = {}
        in_root = False
        for line in section_lines:
            if re.search(r':root\s*\{', line):
                in_root = True; continue
            if in_root and re.search(r'^\s*\}', line):
                in_root = False; continue
            if in_root:
                m = re.match(r'\s*(--wui-[a-zA-Z0-9_-]+)\s*:\s*([^;]+);', line)
                if m:
                    doc_defaults[m.group(1).strip()] = m.group(2).strip()

        root_var_set = set(root_vars.keys())
        only_doc    = sorted(doc_vars - root_var_set)
        only_root_v = sorted(root_var_set - doc_vars)
        value_fails = [(v, root_vars[v], doc_defaults[v])
                       for v in root_vars if v in doc_defaults and doc_defaults[v] != root_vars[v]]

    any_fail = bool(doc_fails or table_fails or field_fails or file_fails
                    or only_doc or only_root_v or value_fails)
    if summary and not any_fail:
        return

    print(f"\n{CYAN}{comp}{RESET}")
    print(f"  version: {src_ver or '?'}")

    if src_ver is None:
        print(f"  [{RED}error{RESET}] no versioned file found in src/wui-js/{KIND}/{comp}/")
        return

    if not summary or doc_fails:
        if has_section:
            print(ok("class documentation."))
        else:
            print(fail("class documentation."))
            print(f"    {RED}docs/{get_class_doc_rel(comp, lang)} not found or missing '{comp_heading(comp)}' heading{RESET}")

    if not summary or table_fails:
        if not table_fails:
            print(ok("class table version."))
        else:
            print(fail("class table version."))
            for lineno, val in table_fails:
                print(fail_detail(lineno, val, src_ver))

    if has_section:
        if not summary or field_fails:
            if not field_fails:
                print(ok("field version."))
            else:
                print(fail("field version."))
                for lineno, val in field_fails:
                    print(fail_detail(lineno, val, src_ver))

        if not summary or file_fails:
            if not file_fails:
                print(ok("files name version."))
            else:
                print(fail("files name version."))
                for lineno, val in file_fails:
                    print(f"    {RED}line {lineno}: '{val}' (expected version {src_ver}){RESET}")

        # ── 5. css vars doc → root.css ────────────────────────────────────────
        if not summary or only_doc:
            if not only_doc:
                print(ok("css vars doc → root.css."))
            else:
                print(fail("css vars doc → root.css."))
                for var in only_doc:
                    print(f"    {RED}'{var}' documented but not in .root.css{RESET}")

        # ── 6. css vars root.css → doc ────────────────────────────────────────
        if not summary or only_root_v:
            if not only_root_v:
                print(ok("css vars root.css → doc."))
            else:
                print(fail("css vars root.css → doc."))
                for var in only_root_v:
                    print(f"    {RED}'{var}' in .root.css but not documented{RESET}")

        # ── 7. css default values ─────────────────────────────────────────────
        if not summary or value_fails:
            if not value_fails:
                print(ok("css default values."))
            else:
                print(fail("css default values."))
                for var, root_val, doc_val in value_fails:
                    print(f"    {RED}'{var}'{RESET}")
                    print(f"      root.css : {root_val}")
                    print(f"      doc      : {doc_val}")


HELP = """
docs-check.py — WUI/JS Documentation Check

Usage:
  python docs-check.py [options] [lang] [component,...]

Arguments:
  lang         Documentation language: en (default) or es.
  component    Component name(s), comma or space separated.
               Use * or omit to check all components.

Options:
  -s, --summary  Show only [fail] results.
  -h, --help     Show this help message.

Examples:
  python docs-check.py
  python docs-check.py es
  python docs-check.py en button
  python docs-check.py -s
  python docs-check.py -s es button,modal
"""

def main():
    args = sys.argv[1:]
    if "-h" in args or "--help" in args:
        print(HELP)
        sys.exit(0)
    summary = "-s" in args or "--summary" in args
    args = [a for a in args if a not in ("-s", "--summary")]

    # Detect if first arg is a language code or a component name
    lang = "en"
    if args and args[0].lower() in ("en", "es"):
        lang = args[0].lower()
        args = args[1:]

    doc_path = os.path.join(REPO, "docs", f"README-{lang}.md")
    if not os.path.isfile(doc_path):
        print(f"File not found: {doc_path}")
        sys.exit(1)

    lines = [l.rstrip("\n") for l in open(doc_path, encoding="utf-8")]
    doc_order = get_doc_order(doc_path)

    raw_comps = " ".join(args).replace(",", " ").split()
    if KIND == "environment":
        src_dirs = set(PLATFORMS)
    else:
        src_dirs = {d for d in os.listdir(MAIN)
                    if os.path.isdir(os.path.join(MAIN, d)) and not d.startswith(".")}
        src_dirs -= {"LICENSE", "wui.js"}

    if not raw_comps or raw_comps == ["*"]:
        order_idx = {c: i for i, c in enumerate(doc_order)}
        selected = sorted(src_dirs, key=lambda c: order_idx.get(c, 999))
    else:
        selected = raw_comps

    lib_ver = get_lib_version()
    print(f"\nWUI/JS - Docs check{' [summary]' if summary else ''}")
    print(f"library: wuijs-{KIND}-lib")
    print(f"lib version: {lib_ver}")
    print(f"language: {lang}")

    for comp in selected:
        if comp not in src_dirs:
            print(f"\n[{RED}error{RESET}] component not found: '{comp}'")
            continue
        src_ver = get_source_version(comp)
        check_component(comp, lang, lines, src_ver, summary=summary)

    print()


if __name__ == "__main__":
    main()
