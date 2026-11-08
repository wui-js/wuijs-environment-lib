# MD

General rules for Markdown. They apply to the `.md` documents in the project scope. Files whose format is fixed by the
tool that consumes them (a change log that follows Keep a Changelog, agent instruction files) are excluded by the
project in its `CODING.md`.

## 1. Headings

A blank line before and after every heading (`#` to `######`), without exception. The closing `---` of a front matter
block counts as the line before the heading that follows it.

Only exception: a heading on the first line of the file has no blank line before it.

---

## 2. Line width

Lines are at most 120 characters long, **outside tables and code blocks**. The limit does not apply to:

- A YAML front matter block: it is structured data, and wrapping it breaks the parser that reads it.
- A table row (`| ... |`): a wide table is legitimate and is not split into lines.
- A URL or a file path without inner spaces, when splitting it is impossible without inserting a character that changes
  its meaning.

The limit is also a target: a paragraph is wrapped **as far as the width allows**, not at an arbitrary comfortable
width. A prose line that still has room for the first word of the next line without passing 120 wastes space, and the
paragraph reads as if it had breaks where there are none. The only exception is a deliberate break used as a unit of
meaning: one list item per line, or a short enumeration.

```markdown
<!-- incorrect: line 1 had room for "that" -->
The manifest declares every path of the project and the category
that applies to it.

<!-- correct -->
The manifest declares every path of the project and the category that applies to it.
```

---

## 3. Tables: alignment

The `|` of each column are aligned vertically across the header, the separator row and every data row. The width of a
column is the maximum among its header, its separator and every cell of that column in the whole table.

```markdown
| Short column | Column with longer content |
| ------------ | -------------------------- |
| a            | long example value         |
```

**`\|` is content, not a column separator.** An escaped bar belongs to the cell that contains it; splitting by it
invents columns and corrupts the table. It is the way to write an alternation inside a cell (`` `<install\|update>` ``),
and whoever aligns the table splits only by the bars that are not preceded by `\`.

---

## 4. Tables: separator row

A space on each side of the separator of each column (`| --- |`, never `|---|`). The separator is filled with dashes up
to the width of the rest of the column (§3), never three dashes padded with spaces. `:` appears only when the column
declares an explicit alignment: `:---` (left), `---:` (right), `:---:` (center).

---

## Verification

```bash
# §2 — prose lines longer than 120 characters (outside code blocks, tables and front matter)
find {scope} -name "*.md" | xargs python3 -c 'import sys
for p in sys.argv[1:]:
 c=f=0
 for n,l in enumerate(open(p,encoding="utf-8"),1):
  l=l.rstrip("\n")
  if n==1 and l=="---": f=1; continue
  if f:
   if l=="---": f=0
   continue
  if l.startswith("```"): c=not c; continue
  if not c and not l.startswith("|") and len(l)>120: print(p+":"+str(n))'

# §4 — separator cells without spaces
grep -rnE "\|-{3,}|-{3,}\|" {scope} --include="*.md"
```

## Manual review

- §1: blank lines around headings.
- §2: where to break a line that passed 120 characters, and lines that waste the available width.
- §3: column alignment of each table.
