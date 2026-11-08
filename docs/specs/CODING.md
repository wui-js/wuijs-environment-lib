# CODING

Coding rules of `wuijs-environment-lib`. The universal specs are copies of `wuijs-specs-lib`, kept with their versioned
file names in `docs/specs/` and `docs/specs/coding/` and never edited here (`specs-0.1.md` §6). A change to a universal
spec goes to `wuijs-specs-lib` first and reaches this library as a new version.

## Scope

The specs apply to:

- `src/wui-js/environment/web/`: JavaScript bridge.
- `src/wui-js/environment/android/`: Android bridge (Java).
- `src/wui-js/environment/ios/`: iOS bridge (Swift).
- `src/wui-js/environment/demo/`: HTML demo.
- `templates/`: the application code of the Android and iOS templates (`MainActivity.java`, `MainView.swift`,
  `MyAppApp.swift`).
- `tests/` (Python) and `tools/` (shell).
- `docs/`, `NPM.md`: documentation.

Excluded:

- `legacy/`: archived versions, never edited.
- `docs/specs/specs-0.1.md` and `docs/specs/coding/`: copies of the universal specs, validated in their source library.
- Files ignored by git (`.claude/`, `CLAUDE.md`, `MEMORY.md`, `NOTES.md`, `__pycache__/`), except `NPM.md`.
- Files whose format a tool defines: `package.json`, `.gitignore`, `.npmignore`.
- The copies of the library files inside `templates/` (`**/assets/libraries/`, `**/WUIEnvironment.java`,
  `**/WUIEnvironment.swift`): `tools/sync-templates.sh` copies them from `src/`.
- Android and iOS build and IDE configuration: `.kts`, `.xml`, `.pro`, `.toml`, `.properties`, `gradlew`, `gradlew.bat`,
  `.plist`, `.pbxproj`, asset catalogs (`Contents.json`) and images.
- `.vscode/`.

## Specs

| Spec                  | Version | Applies to            |
| --------------------- | ------- | --------------------- |
| `specs-0.1.md`        | `0.1`   | every file in scope   |
| `coding/js-0.1.md`    | `0.1`   | the JavaScript bridge |
| `coding/java-0.1.md`  | `0.1`   | the Java code         |
| `coding/swift-0.1.md` | `0.1`   | the Swift code        |
| `coding/html-0.1.md`  | `0.1`   | the demo              |
| `coding/sh-0.1.md`    | `0.1`   | the shell tools       |
| `coding/py-0.1.md`    | `0.1`   | the Python checks     |
| `coding/md-0.1.md`    | `0.1`   | the documentation     |

## Verification

Validation follows `specs-0.1.md` §7: read this file and every enabled spec, run every command of the `Verification`
section of each spec with `{scope}` replaced by the value below, then go through its `Manual review`, and report a table
of spec, rule and status.

| Spec                  | `{scope}`                                                                                                                            |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `coding/js-0.1.md`    | `src/wui-js/environment/web`                                                                                                         |
| `coding/java-0.1.md`  | `src/wui-js/environment/android` `templates/app.myapp.android/app/src/main/java/app/myapp/MainActivity.java`                         |
| `coding/swift-0.1.md` | `src/wui-js/environment/ios` `templates/app.myapp.ios/MyApp/MainView.swift` `templates/app.myapp.ios/MyApp/MyAppApp.swift`           |
| `coding/html-0.1.md`  | `src/wui-js/environment/demo`                                                                                                        |
| `coding/sh-0.1.md`    | `tools`                                                                                                                              |
| `coding/py-0.1.md`    | `tests`                                                                                                                              |
| `coding/md-0.1.md`    | `docs/README-es.md` `docs/README-en.md` `docs/CHANGELOG-es.md` `docs/CHANGELOG-en.md` `docs/classes` `docs/specs/CODING.md` `NPM.md` |

Library checks, run from the repository root (empty failure list = pass):

| Command                             | Checks                                                 |
| ----------------------------------- | ------------------------------------------------------ |
| `python3 tests/docs-check.py -s es` | versions of the class docs (Spanish)                   |
| `python3 tests/docs-check.py -s en` | the same for English                                   |
| `tools/sync-templates.sh`           | refreshes the template copies after a change in `src/` |

## Transversal rules

`specs-0.1.md` §8 applies to every language: a comment only labels, with one line; it never explains. The rules of this
library that apply to every language:

- Each bridge has its own version, carried in its `@version` header (and in the file name of the JavaScript bridge). A
  version bump archives the current files in `legacy/`.
- The Java and Swift bridges keep functional parity (`java-0.1.md` §10, `swift-0.1.md` §10): a change in one is made and
  tested in the other before it is considered complete.
- The library version `X.Y.Z` (`VERSION`, `package.json`) follows the highest bridge version in `X.Y`; `Z` is the
  modification number.
- Documentation is kept in Spanish and English with the same structure and the same line count (`*-es.md` / `*-en.md`).
- `.DS_Store` files are never tracked.

## Explanations

The reasons behind non-obvious decisions (specs-0.1.md §8) live in the class documentation (`docs/classes/<name>/`) and
in the CHANGELOG entry of the change, never in code comments. This library has no codemap.

## Project specs

None.
