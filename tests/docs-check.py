#!/usr/bin/env python3
"""WUI/JS documentation check: versions of source files against the class table and class documents."""

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
	"data":        {"prefix": "wuidata",   "cls": "WUIData"},
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

def getLibVersion():
	if os.path.isfile(WUI_JS):
		for line in open(WUI_JS, encoding="utf-8"):
			m = re.search(r'const version\s*=\s*"([^"]+)"', line)
			if m:
				return m.group(1)
		return "?"
	versionPath = os.path.join(REPO, "VERSION")
	return open(versionPath, encoding="utf-8").read().strip() if os.path.isfile(versionPath) else "?"

def getClassName(comp):
	if KIND == "environment":
		return "WUIEnvironment"
	return LIBS[KIND]["cls"] + comp[0].upper() + comp[1:]

def getHeading(comp):
	if KIND == "environment":
		return f"# WUIEnvironment ({PLATFORMS[comp][0]})"
	return f"# {getClassName(comp)}"

def getFileName(comp):
	"""File name stem of the sources: button → wui-button, environment platforms → wui-environment."""
	return "wui-environment" if KIND == "environment" else f"{PREFIX}-{comp}"

def getDirectory(comp):
	return os.path.join(MAIN, "web" if KIND == "environment" else comp)

def getSourceVersion(comp):
	if KIND == "environment" and PLATFORMS[comp][1]:
		path = os.path.join(MAIN, PLATFORMS[comp][1])
		if os.path.isfile(path):
			for line in open(path, encoding="utf-8"):
				m = re.search(r'@version\s+([0-9.]+)', line)
				if m:
					return m.group(1)
		return None
	name = getFileName(comp)
	for ext in ("js", "css"):
		files = [f for f in glob.glob(os.path.join(getDirectory(comp), f"{name}-*.{ext}"))
			if ".root." not in f]
		if files:
			m = re.search(rf"{name}-([0-9.]+)\.{ext}$", os.path.basename(files[0]))
			if m:
				return m.group(1)
	return None

def getDocOrder(docPath):
	"""Return component names in class table order."""
	if KIND == "environment":
		return list(PLATFORMS)
	order, seen = [], set()
	for line in open(docPath, encoding="utf-8"):
		m = re.match(rf'\|\s*\[?({LIBS[KIND]["cls"]}(\w+))\]?[^|]*\|\s*`[0-9.]+`', line)
		if m:
			comp = m.group(2).lower()
			if comp not in seen:
				seen.add(comp)
				order.append(comp)
	return order

def getClassDocRel(comp, lang):
	"""Return the class documentation path relative to docs/: button → classes/button/wui-button-en.md."""
	if KIND == "environment":
		return f"classes/environment/wui-environment-{comp}-{lang}.md"
	return f"classes/{comp}/{PREFIX}-{comp}-{lang}.md"

def getClassDocPath(comp, lang):
	return os.path.join(DOCS, getClassDocRel(comp, lang))

def getClassLines(comp, lang):
	"""Return the class documentation lines, or None if the file or its # WUI<Name> heading is missing."""
	path = getClassDocPath(comp, lang)
	if not os.path.isfile(path):
		return None
	lines = [l.rstrip("\n") for l in open(path, encoding="utf-8")]
	heading = getHeading(comp)
	if not any(line.strip().lower() == heading.lower() for line in lines):
		return None
	return lines

def printOk(text):
	return f"  [{GREEN}pass{RESET}] {text}"

def printFail(text):
	return f"  [{RED}fail{RESET}] {text}"

def printFailDetail(lineno, value, expected):
	return f"    {RED}line {lineno}: '{value}' (expected '{expected}'){RESET}"

def checkComponent(comp, lang, lines, srcVer, summary=False):
	cls = getClassName(comp)
	# ── 1. Class documentation ─────────────────────────────────────────────
	sectionLines = getClassLines(comp, lang)
	hasSection = sectionLines is not None
	docFails = not hasSection
	# ── 2. Class table version ─────────────────────────────────────────────
	tableFails = []
	inTable = False
	for i, line in enumerate(lines):
		if re.search(r'\|\s*(Class name|Nombre Clase|Clase)\s*\|', line, re.IGNORECASE):
			inTable = True
		if not inTable:
			continue
		if inTable and line.strip() == "":
			inTable = False
			continue
		if KIND == "environment":
			m = re.match(rf'\|\s*\[?{cls}\]?\([^)]*-{comp}-{lang}\.md\)[^`]*`([0-9.]+)`', line)
		else:
			m = re.match(rf'\|\s*\[?{cls}\]?[^|]*\|\s*`([0-9.]+)`', line, re.IGNORECASE)
		if m:
			if m.group(1) != srcVer:
				tableFails.append((i + 1, m.group(1)))
			break
	# ── 3. Field version ───────────────────────────────────────────────────
	fieldFails = []
	if hasSection:
		offset = 0
		for i, line in enumerate(sectionLines):
			m = re.match(r'\s*Versi[oó]n:\s*`([0-9.]+)`', line, re.IGNORECASE) or \
				re.match(r'\s*Version:\s*`([0-9.]+)`', line, re.IGNORECASE)
			if m and m.group(1) != srcVer:
				fieldFails.append((offset + i + 1, m.group(1)))
	# ── 4. Files name version ──────────────────────────────────────────────
	fileFails = []
	if hasSection:
		filePattern = re.compile(rf'{getFileName(comp)}-([0-9.]+)\.(root\.css|css|js)')
		for i, line in enumerate(sectionLines):
			seenInLine = set()
			for m in filePattern.finditer(line):
				matchStr = m.group(0)
				if m.group(1) != srcVer and matchStr not in seenInLine:
					seenInLine.add(matchStr)
					fileFails.append((offset + i + 1, matchStr))
	# ── 5/6/7: root.css vs documentation CSS variables (pre-compute) ──────────
	onlyDoc = onlyRootV = valueFails = []
	docVars = docDefaults = rootVars = {}
	if hasSection:
		rootPath = os.path.join(getDirectory(comp), f"{getFileName(comp)}-{srcVer}.root.css")
		rootVars = {}
		if os.path.isfile(rootPath):
			for line in open(rootPath, encoding="utf-8"):
				m = re.match(r'\s*(--wui-[a-zA-Z0-9_-]+)\s*:\s*([^;]+);', line)
				if m:
					rootVars[m.group(1).strip()] = m.group(2).strip()
		docVars = set()
		for line in sectionLines:
			m = re.match(r'\|\s*`(--wui-[a-zA-Z0-9_-]+)`', line)
			if m:
				docVars.add(m.group(1))
		docDefaults = {}
		inRoot = False
		for line in sectionLines:
			if re.search(r':root\s*\{', line):
				inRoot = True; continue
			if inRoot and re.search(r'^\s*\}', line):
				inRoot = False; continue
			if inRoot:
				m = re.match(r'\s*(--wui-[a-zA-Z0-9_-]+)\s*:\s*([^;]+);', line)
				if m:
					docDefaults[m.group(1).strip()] = m.group(2).strip()
		rootVarSet = set(rootVars.keys())
		onlyDoc    = sorted(docVars - rootVarSet)
		onlyRootV = sorted(rootVarSet - docVars)
		valueFails = [(v, rootVars[v], docDefaults[v])
			for v in rootVars if v in docDefaults and docDefaults[v] != rootVars[v]]
	anyFail = bool(docFails or tableFails or fieldFails or fileFails
		or onlyDoc or onlyRootV or valueFails)
	if summary and not anyFail:
		return
	print(f"\n{CYAN}{comp}{RESET}")
	print(f"  version: {srcVer or '?'}")
	if srcVer is None:
		print(f"  [{RED}error{RESET}] no versioned file found in src/wui-js/{KIND}/{comp}/")
		return
	if not summary or docFails:
		if hasSection:
			print(printOk("class documentation."))
		else:
			print(printFail("class documentation."))
			print(f"    {RED}docs/{getClassDocRel(comp, lang)} not found or missing '{getHeading(comp)}' heading{RESET}")
	if not summary or tableFails:
		if not tableFails:
			print(printOk("class table version."))
		else:
			print(printFail("class table version."))
			for lineno, val in tableFails:
				print(printFailDetail(lineno, val, srcVer))
	if hasSection:
		if not summary or fieldFails:
			if not fieldFails:
				print(printOk("field version."))
			else:
				print(printFail("field version."))
				for lineno, val in fieldFails:
					print(printFailDetail(lineno, val, srcVer))
		if not summary or fileFails:
			if not fileFails:
				print(printOk("files name version."))
			else:
				print(printFail("files name version."))
				for lineno, val in fileFails:
					print(f"    {RED}line {lineno}: '{val}' (expected version {srcVer}){RESET}")
		# ── 5. css vars doc → root.css ────────────────────────────────────────
		if not summary or onlyDoc:
			if not onlyDoc:
				print(printOk("css vars doc → root.css."))
			else:
				print(printFail("css vars doc → root.css."))
				for var in onlyDoc:
					print(f"    {RED}'{var}' documented but not in .root.css{RESET}")
		# ── 6. css vars root.css → doc ────────────────────────────────────────
		if not summary or onlyRootV:
			if not onlyRootV:
				print(printOk("css vars root.css → doc."))
			else:
				print(printFail("css vars root.css → doc."))
				for var in onlyRootV:
					print(f"    {RED}'{var}' in .root.css but not documented{RESET}")
		# ── 7. css default values ─────────────────────────────────────────────
		if not summary or valueFails:
			if not valueFails:
				print(printOk("css default values."))
			else:
				print(printFail("css default values."))
				for var, rootVal, docVal in valueFails:
					print(f"    {RED}'{var}'{RESET}")
					print(f"      root.css : {rootVal}")
					print(f"      doc      : {docVal}")

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
	docPath = os.path.join(REPO, "docs", f"README-{lang}.md")
	if not os.path.isfile(docPath):
		print(f"File not found: {docPath}")
		sys.exit(1)
	lines = [l.rstrip("\n") for l in open(docPath, encoding="utf-8")]
	docOrder = getDocOrder(docPath)
	rawComps = " ".join(args).replace(",", " ").split()
	if KIND == "environment":
		srcDirs = set(PLATFORMS)
	else:
		srcDirs = {d for d in os.listdir(MAIN)
			if os.path.isdir(os.path.join(MAIN, d)) and not d.startswith(".")}
		srcDirs -= {"LICENSE", "wui.js"}
	if not rawComps or rawComps == ["*"]:
		orderIdx = {c: i for i, c in enumerate(docOrder)}
		selected = sorted(srcDirs, key=lambda c: orderIdx.get(c, 999))
	else:
		selected = rawComps
	libVer = getLibVersion()
	print(f"\nWUI/JS - Docs check{' [summary]' if summary else ''}")
	print(f"library: wuijs-{KIND}-lib")
	print(f"lib version: {libVer}")
	print(f"language: {lang}")
	for comp in selected:
		if comp not in srcDirs:
			print(f"\n[{RED}error{RESET}] component not found: '{comp}'")
			continue
		srcVer = getSourceVersion(comp)
		checkComponent(comp, lang, lines, srcVer, summary=summary)
	print()

if __name__ == "__main__":
	main()
