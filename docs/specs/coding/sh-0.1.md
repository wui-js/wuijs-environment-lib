# SH

General rules for shell scripts. They apply to every `.sh` file in the project scope, executable scripts and library
files loaded with `.`.

## 1. Header

Every script starts with `#!/usr/bin/env bash` followed immediately by `set -eu` (abort on an undefined variable or a
failed command), with no blank line between them.

```bash
#!/usr/bin/env bash
set -eu
```

No exceptions: a library file loaded with `.` has the same header and no comment that identifies it as a library.

---

## 2. Indentation

Indentation uses the tab character `\t`.

---

## 3. Blank lines

- The separator is **a single blank line, never two or more in a row**, anywhere in the file, heredoc content included.
- No blank line between `#!/usr/bin/env bash` and `set -eu`.
- No blank lines inside a block of related variable assignments.
- A blank line between consecutive functions.
- A blank line before and after a block label (§4).
- **Inside a function body, no blank line is valid**, nested functions included. The literal content of a heredoc is
  text, not a statement separator: there only the first rule applies.
- **Outside the cases above, a top-level section that is not an assignment block has no inner blank line.** A blank line
  is valid only when one of its two neighbours (ignoring comments) is the last or first line of an assignment block: a
  `NAME=value` line, or a short assigning guard (`[ condition ] && NAME=value`), continuations with `\` included.

```bash
TARGET_LANG=""
PATHS=()

for arg in "$@"; do
	...
done
[ -n "$TARGET_LANG" ] || die "Missing --lang. See --help."
```

The blank line is valid because `PATHS=()` closes an assignment block. A blank line after `done` would not be: neither
`done` nor the guard that follows it is an assignment.

---

## 4. Block labels

A block label marks the start of a thematic block of the script: a short word or phrase in uppercase, right before the
block it names, optionally followed by a free clarification after an em dash or in parentheses.

```bash
# LOAD CONFIG

APP_NAME=$(getConfig "appName")

# REQUIREMENTS — jq

command -v jq >/dev/null 2>&1 || { ... }
```

`# shellcheck ...` directives are syntax, not labels (`specs-0.1.md` §8).

---

## 5. Block structure

Every script is organized in fixed blocks, in this order, each marked with a one-line `# {BLOCK}` label in uppercase,
with a blank line before and after it. **Blocks only define; execution happens in `MAIN`.**

### 5.1. Executable scripts

| Block       | Content                                                                            | Required |
| ----------- | ---------------------------------------------------------------------------------- | -------- |
| `GLOBAL`    | the loading of shared library files, and the variables used by more than one block | yes      |
| `HELPERS`   | utility functions, `help()` included                                               | yes      |
| `ARGUMENTS` | `ARGS_*` variables with their default, and `parseArguments()`                      | yes      |
| `VALIDATE`  | consistency of arguments and dependencies (required commands, accepted values)     | no       |
| `ACTIONS`   | sequential functions of the process                                                | no       |
| `COMMANDS`  | one function per command, named `command{Name}`                                    | no       |
| `CLEANUP`   | `cleanup()`, invoked from a `trap`                                                 | no       |
| `MAIN`      | only calls to functions already defined                                            | yes      |

Configuration is not a block: it is loaded in `loadConfig()`, the first function of `ACTIONS`, because it reads files
and may abort. Its results go to `GLOBAL_*` variables.

`MAIN` has two forms, depending on whether the script has commands:

```bash
parseArguments "$@"        parseArguments "$@"
validateArguments          loadConfig
loadConfig                 runCommand "$ARGS_COMMAND"
syncFiles
buildBinary
```

With commands, a shared dispatcher resolves the command name to its `command{Name}` function and aborts with a uniform
message when it does not exist: no script writes its own dispatch `case`.

### 5.2. Library files

A file loaded with `.` has no `ARGUMENTS` or `MAIN`. Its functions are grouped by nature in labeled blocks, for example:

| Block      | Groups                                    |
| ---------- | ----------------------------------------- |
| `GLOBAL`   | shared state variables                    |
| `FORMAT`   | format their arguments and return them    |
| `INPUT`    | read from STDIN                           |
| `OUTPUT`   | write to STDOUT                           |
| `DATA`     | read and parse file formats               |
| `PLATFORM` | query the operating system and toolchain  |
| `CONTROL`  | shared execution flow (dispatch, cleanup) |

A generic shell utility and the domain logic of a project live in separate library files.

### 5.3. Position of functions

- A utility or auxiliary function used by a single block goes in `HELPERS`.
- A function that is **part of the process** and is only called by another function of the same block is declared in
  that block, next to its caller; it is not hoisted to `HELPERS`.

### 5.4. Order of the functions that `MAIN` invokes

Inside each block, the functions that `MAIN` invokes **directly by name** are declared in the same order in which `MAIN`
invokes them. The order between blocks is still fixed by §5.1: this rule never moves a function to another block, it
only orders inside each one.

```bash
# ACTIONS

loadConfig() { ... }
seedModule() { ... }
installDatabase() { ... }

# MAIN

parseArguments "$@"
loadConfig
seedModule
installDatabase
```

It does not apply to what `MAIN` does not invoke by name: `COMMANDS` functions (reached through the dispatcher) and the
helpers or inner functions placed by §5.3.

---

## 6. Variables and functions

- **Global and configuration variables**: `UPPER_SNAKE_CASE` prefixed with the block that declares them
  (`GLOBAL_APP_NAME`, `ARGS_ENV`, `ACTIONS_COUNT`). The prefix tells where each value comes from without searching for
  it. A variable used only by its own block takes that block's prefix; one that crosses blocks goes in `GLOBAL`. The
  prefix of `ARGUMENTS` is **`ARGS_`**, not `ARGUMENTS_`.
- **No associative arrays** (`declare -A`): they need bash 4, and the system bash on macOS is 3.2. The prefix does the
  same grouping without raising the requirement.
- **Function local variables**: `lowerCamelCase` or a simple lowercase word, always declared with `local` (`local
  msg="$1"`, `local key="$1" file="$2"`). They go at the start of the block that uses them, or as soon as their
  dependencies are available. A function without distinct phases has a single `local` with all its variables; a second
  `local` is justified only when that group depends on something that happens after the first (`shift`, a validation
  that may end the function, a previous computation).
- **Functions**: `[{module}]{verb}{Noun}` in camelCase. The verb names the action and the noun what it operates on
  (`getConfig`, `parseArguments`). An optional module prefix groups the functions of a module, since bash has no
  namespaces; it goes before the verb (`backupCompress`, `commandStart`, `menuPrint`). A function named only after its
  module is not allowed.

```bash
# correct
getAbsPath() { ... }
getChecksum() { ... }
menuPrint() { ... }
backupCompress() { ... }

# incorrect: no verb
absPath() { ... }
checksum() { ... }

# incorrect: named only after its module
menu() { ... }
```

- **Aligned assignments**: when consecutive lines assign variables from the same function, the opening parentheses are
  aligned in the same column, so the key names read as a column.

```bash
APP_NAME=$(      getConfig "appName")
APP_DOMAIN=$(    getConfig "appDomain")
DB_HOST=$(       getConfig "dbHost")
```

- **Booleans**: the literal strings `true`/`false` (not `0`/`1`), evaluated directly as a command (`if $CLEAR; then`),
  not with `[ "$CLEAR" = "true" ]`.

---

## 7. Confirmations

Every optional or destructive action is conditioned on a confirmation function chained with `&&`/`||`, never with an
explicit `if`/`else` for this case.

```bash
ask "Clear the database? (WARNING: irreversible)" && {
	...
} || true
```

The final `|| true` is required unless a missing confirmation must abort the script; then it is replaced by `|| { echo
"..."; exit 1; }`.

---

## 8. Help text

The help text is written with `cat <<-EOF`, unquoted so that substitutions expand. Its sections always go in this order,
omitting those that do not apply. It follows the structure of `man(7)` pages with the convention of CLIs with
subcommands: commands before options, and lists of argument values between them.

| #   | Section                                | Content                                          |
| --- | -------------------------------------- | ------------------------------------------------ |
| 1   | title                                  | `name.sh — summary`, without heading             |
| 2   | `USAGE`                                | one line per invocation form                     |
| 3   | `DESCRIPTION`                          | what it does and why, in prose or numbered steps |
| 4   | `COMMANDS`                             | one subcommand per line                          |
| 5   | value lists (`SET`, `CATEGORIES`, ...) | the values accepted by an argument or option     |
| 6   | `OPTIONS`                              | one option per line, `-h, --help` always last    |
| 7   | files (`OUTPUTS`, ...)                 | what the tool writes or generates                |
| 8   | notes                                  | paragraphs without heading                       |
| 9   | highlighted footer (`Requires:`, ...)  | requirements or warnings                         |

A paragraph that explains a specific section goes right after it and moves with it; only the general closing text goes
in notes. A value list generated from a catalog is printed by a function and never written by hand. Section headings may
be emphasized; the rest of the text has no formatting.

---

## 9. Inheritable variables

A variable that is a contract between a script and the scripts it invokes (a non-interactive flag, a verbosity flag) is
always declared in the form that respects the environment, and exported after parsing the arguments.

```bash
ARGS_YES_ALL=${ARGS_YES_ALL:-false}
...
export ARGS_YES_ALL
```

Writing `ARGS_YES_ALL=false` alone overwrites the inherited value and silently breaks the chain.

---

## Verification

```bash
# §1 — header
find {scope} -name "*.sh" | while read f; do [ "$(head -2 "$f")" = "$(printf '#!/usr/bin/env bash\nset -eu')" ] || echo "$f"; done

# §2 — indentation with spaces
grep -rnE "^( {2}| {4})" {scope} --include="*.sh"

# §3 — two or more consecutive blank lines
find {scope} -name "*.sh" | xargs awk 'FNR==1{b=0} /^[ \t]*$/{if(b){print FILENAME":"FNR}; b=1; next} {b=0}'

# §6 — associative arrays
grep -rnE "declare[[:space:]]+-A" {scope} --include="*.sh"
```

## Manual review

- §3: blank lines inside functions and in top-level sections.
- §4: each label names the block it heads.
- §5.1: blocks present and their order; §5.3: position of single-use functions; §5.4: order of the functions `MAIN`
  invokes.
- §6: variable and function name forms (`[{module}]{verb}{Noun}`); whether a second `local` is justified by a later
  dependency.
- §8: help sections and their order.
- §9: inheritable variables declared with `${VAR:-default}` and exported.
