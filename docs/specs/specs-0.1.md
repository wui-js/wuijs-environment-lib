# Specs

General specification of the WUIJS specs: how they are named, organized, versioned, adopted by a project and applied.
Every other spec in this library presupposes this one.

## 1. Purpose

The specs define how code and user-facing content are written in any WUIJS project. They are universal: a new project
adopts them without modifying them. Rules that only make sense inside one project live in that project, not here.

---

## 2. Structure

```
src/wui-js/specs/
├── specs-{version}.md
├── coding/
│   ├── {language}-{version}.md
│   └── {language}-{use}-{version}.md
└── content/
    └── {language}-{version}.md
```

- `coding/` holds the rules for writing code, one language per file.
- `content/` holds the rules for user-facing text, one natural language per file (e.g. `lang-es`).

---

## 3. Naming

- `{language}-{version}.md`: general rules of a language. They apply to every file of that language in the project
  scope: indentation, line breaks, naming of classes, variables, functions and methods, declarations, comparisons.
- `{language}-{use}-{version}.md`: rules of a particular use of the language (e.g. `js-fragments`). They apply only to
  the files of that use and presuppose the general file of the language.
- `{language}` is the identifier of the file extension in lowercase (`js`, `css`, `html`, `json`, `md`, `py`, `sh`,
  `sql`, `go`, `java`, `swift`). One identifier covers every extension of the same language (`html` covers `.html` and
  `.htm`).
- `{use}` is a single kebab-case word or phrase in plural when it names a kind of file (`fragments`, `pages`,
  `components`).
- `{version}` is `X.Y` (see §9).

---

## 4. Precedence

- A `{language}-{use}` file extends or restricts its `{language}` file. It never repeats it.
- A project may add its own transversal rules and its own specs (see §6). It may make a universal rule more precise,
  never exempt itself from it.
- When two rules conflict, the more specific one wins: project spec over `{language}-{use}`, `{language}-{use}` over
  `{language}`.

---

## 5. Inclusion

A spec belongs in this library when it applies to two or more projects, or to any new project of its kind. A spec that
depends on the structure of a single project stays in that project.

Every project that uses a language must adopt that language's general spec. Files that are generated, maintained by an
IDE or copied from a third party are not covered; the project lists them as exclusions in its `CODING.md`.

---

## 6. Adoption by a project

1. The project keeps a copy of each spec it uses, with the same versioned file name, in its specs directory.
2. Copies are never edited inside the project. A change goes to this library first and reaches the project as a new
   version.
3. The project has a `CODING.md` at the root of its specs directory with:
   - **Scope**: the paths the specs apply to, and the excluded paths and files.
   - **Specs**: the enabled specs with their versions.
   - **Verification**: the command that validates each extension and use, with `{scope}` resolved.
   - **Transversal rules**: the project's own rules that apply to every language.
   - **Explanations**: where the reasons behind non-obvious decisions live (§8), since they never live in the code.
   - **Project specs**: the specs that live only in this project.
4. Updating a spec in a project is an explicit change: replace the copy, update `CODING.md`, and validate the code
   against the new version.

---

## 7. Validation

Validation applies when a code file is created or modified, and when a review of the project against its specs is
requested. A file is not finished until it passes its validation.

1. Read `CODING.md` and every spec it enables, not only the one of the file under review.
2. Run every command of the `Verification` section of each applicable spec over the scope defined in `CODING.md`. When a
   tool applies deterministic fixes, apply them before the manual review.
3. Go through the `Manual review` section of each applicable spec. Passing the commands covers only the automatable part
   of a spec.
4. Report the result as a table: spec, rule, status (✅ / ❌), detail with file and line.

Validation is never replaced by a narrative review alone, by sampling, or by splitting the files without verifying full
coverage.

---

## 8. Transversal rules

Rules that apply to every language and are not repeated in the language specs.

1. **Comments**: a comment may only label, with one line that marks a block or a group. It never explains.
2. The reason behind a non-obvious decision does not live in the code. Each project's `CODING.md` defines where it goes
   (for example, a codemap or the project documentation).
3. A comment of more than one line is an explanation by construction, so it is not allowed.
4. Exception: a directive addressed to a tool (`# shellcheck disable=...`, `//go:embed`, `/* stylelint-disable */`) is
   syntax, not a comment.

Each language spec defines only the form its label takes.

---

## 9. Versioning

- Each spec has its own version `X.Y`, carried in its file name.
- A change in the meaning of a rule (a rule added, removed or changed) creates a new version: the previous file is
  archived in `legacy/wui-js/specs/` under the same category, and the new one replaces it in `src/`.
- A change that does not alter the meaning of any rule (wording, typos, examples) keeps the version.
- Every new version has an entry in the library `CHANGELOG`.
- The library version `X.Y.Z` follows the highest spec version in `X.Y`; `Z` is the modification number.

---

## 10. Language

- Specs are written in English. The English file in `src/` is the only normative text.
- `docs/specs/` holds a Spanish translation of each spec, for reading only. It mirrors the tree of `src/` without
  version and with the `-es` suffix (`docs/specs/coding/js-es.md`) and keeps the same sections and numbering.
- A new version updates its Spanish translation in the same change.

---

## 11. Format of a spec

1. Title with the language and, when it applies, the use.
2. A scope paragraph: which files the spec applies to.
3. Numbered sections (`## 1.`, `## 2.`, ...), separated by `---`, each with its rule and, when useful, `correct` and
   `incorrect` examples.
4. No paths, repository names or project tools. A command refers to the files under review as `{scope}`.
5. A closing `Verification` section with the commands of the automatable rules. Empty output means no violations.
6. A closing `Manual review` section listing the rules that require reading the code.

---

## Verification

```bash
# §3 — spec file names out of convention
find src/wui-js/specs -name "*.md" | grep -Ev "/specs-[0-9]+\.[0-9]+\.md$|/(coding|content)/[a-z]+(-[a-z]+)*-[0-9]+\.[0-9]+\.md$"

# §10 — Spanish translations missing for a spec
find src/wui-js/specs -name "*.md" | sed -E 's#^src/wui-js/specs/#docs/specs/#; s#-[0-9]+\.[0-9]+\.md$#-es.md#' | while read f; do [ -f "$f" ] || echo "$f"; done

# §11 — paths or repository names inside a spec
grep -rnE "wuijs-[a-z]+(-lib)?|src/www|harness/" src/wui-js/specs | grep -v "^src/wui-js/specs/specs-0.1.md:"
```

## Manual review

- §4: a `{language}-{use}` file does not repeat rules of its `{language}` file.
- §5: every spec in the library applies to two or more projects.
- §8: no comment explains; a comment is one line that labels a block or a group.
- §10: each Spanish translation has the same sections and numbering as its English file and is up to date.
