# PY

General rules for Python. They apply to every `.py` file in the project scope.

## 1. Header

A `.py` file that is run directly has `#!/usr/bin/env python3` on its first line. A module that is only imported does
not.

Below it goes the module docstring: **a single line** that names the role of the file.

```python
#!/usr/bin/env python3
"""Single index of the UI tree that every static check reads."""
```

---

## 2. Indentation

Indentation uses the tab character `\t`, one level per block, without exception. Python uses indentation as syntax, so
mixing tabs and spaces in one file is not a style problem but an execution problem.

The continuation of an expression inside parentheses is indented with one additional tab, never with spaces up to the
opening parenthesis.

---

## 3. Blank lines

- Between two top-level functions or classes: **a single blank line**. Never two.
- Between two methods of the same class: a single blank line.
- **Inside the body of a function: none.** Not at the start, not at the end, not between logical stages. A function that
  needs to breathe inside is doing two things and must be split.
- A blank line after the `import` block, and one after the module-level declarations, before the first function.

```python
# correct
RE_KEY = re.compile(r"^\w+:")

def parseLine(line):
	match = RE_KEY.match(line)
	if not match:
		return None
	return match.group(0)

def parseFile(path):
	return [parseLine(line) for line in open(path)]
```

---

## 4. Declarations at the start of the block

Module constants, compiled regular expressions and state variables go **at the start of the file**, after the `import`
block and before the first function. They are not placed between functions or further down because of their first use.

Order of the file:

1. Value constants (`UPPER_SNAKE`).
2. Compiled regular expressions (`RE_*`).
3. Module state variables, if any.
4. Helper functions.
5. Classes.
6. Entry point (`main()` and its `if __name__ == "__main__":`).

Inside a function the same rule applies on a small scale: the assignments the function uses across its body go at the
beginning, not scattered where they are first needed.

---

## 5. Identifier naming

Identifiers are in English. Variables, parameters, functions and methods in **camelCase**; classes in **PascalCase**;
module constants in **UPPER_SNAKE**.

```python
RE_DATA_KEY = re.compile(r'data-key="([^"]+)"')

class MarkupIndex:
	def handleStartTag(self, tag, attrs):
		elementDepth = len(self.stack)
```

This is a deliberate deviation from PEP 8, which asks for `snake_case`. A WUIJS project mixes Python with JavaScript and
other languages that share concepts with the same name (`sectionSlug`, `clientIp`, `rateLimit`); one concept written in
two forms depending on the file forces a mental translation at every jump. Consistency across languages is worth more
than consistency with the convention of one of them.

**Only exception**: what the standard library or an external protocol imposes (`handle_starttag` of `html.parser`,
`__name__`, `sys.argv`) keeps its name. This includes the overrides of methods defined by a standard-library or
third-party interface (`handle_starttag` in a subclass of `HTMLParser`). It is not style, it is the interface.

A leading underscore marks what is private to the module or the class (`_serve`, `self._elements`).

---

## 6. Function and method naming

Every function and method, public or private, is named **`{verb}{Noun}`** (in the casing of §5). The verb says what it
does and comes first; the noun, on what it operates, comes after the verb, never before.

```python
parseSelector(selector)      # correct
resolveClientIp(request)     # correct
buildEnvFile(environment)    # correct

selectorParser(selector)     # incorrect: a noun, does not say what it does
process(data)                # incorrect: no noun
handle(x)                    # incorrect: empty verb
```

Recommended verb prefixes:

| Verb      | Meaning                                                 |
| --------- | ------------------------------------------------------- |
| `parse`   | Converts text into a structure.                         |
| `build`   | Builds a new value from its parts.                      |
| `resolve` | Decides a value among several possible sources.         |
| `load`    | Reads from disk or from the network.                    |
| `write`   | Writes to disk.                                         |
| `check`   | Verifies and returns a boolean.                         |
| `run`     | Runs a complete process and returns its result.         |
| `render`  | Produces the output form of something already computed. |

**Accepted exceptions**: a predicate may be named `isX`/`hasX` instead of `checkX`, and the conventional entry point is
`main()`.

A function declared inside another function or method follows the same structure. Its name is already scoped by the
function that contains it, so it stays simple and never repeats the name of its parent.

---

## 7. Error handling

- **Early return**: validate and return on the case that does not apply, without a nested `else`.
- An `except` names the exception it expects. `except Exception` only where the explicit goal is to keep the process
  alive (a runner collecting the failure of a test), and there the error is reported, never discarded silently.
- `except: pass` is forbidden without exception.

---

## 8. File naming

A script that is only run directly is named in kebab-case, like the files of the other languages (`docs-check.py`). A
module that is imported, including a script that is also imported, is named in lowercase `snake_case` (`lang_es.py`): an
`import` statement only accepts a valid identifier, so a hyphen in a module name is a syntax error.

Each file groups a single role inside its package.

---

## Verification

```bash
# §1 — docstrings of more than one line at module start
find {scope} -name "*.py" | xargs awk 'FNR<=3 && /^"""/ && !/^""".*"""$/ {print FILENAME":"FNR}'

# §2 — indentation with spaces
grep -rnE "^( {2}| {4})" {scope} --include="*.py"

# §3 — two or more consecutive blank lines
find {scope} -name "*.py" | xargs awk 'FNR==1{b=0} /^[ \t]*$/{if(b){print FILENAME":"FNR}; b=1; next} {b=0}'

# §5 — snake_case functions outside classes with a base class (overrides of an imposed interface keep their name)
find {scope} -name "*.py" | xargs awk 'FNR==1{o=0} /^class /{o=($0 ~ /^class [A-Za-z0-9_]+\(.+\)/)} /^[^[:space:]#]/ && !/^class /{o=0} /^[[:space:]]*def [a-z]+_[a-z_]+\(/ && !o {print FILENAME":"FNR}'

# §7 — bare except and silent except
grep -rnE "^[[:space:]]*except[[:space:]]*:|^[[:space:]]*except[^:\"']*:[[:space:]]*pass([^[:alnum:]_]|$)" {scope} --include="*.py"

# §8 — modules with hyphens (files without a shebang)
find {scope} -name "*-*.py" | while read f; do head -1 "$f" | grep -q "^#!" || echo "$f"; done
```

## Manual review

- §1: the docstring describes the real role of the file.
- §3: blank lines inside function bodies.
- §4: declarations of the start of the block are complete, none scattered.
- §5: a snake_case method inside a class with a base class is valid only if it overrides an imposed interface.
- §6: the name of each function says what it does.
- §7: each `except Exception` is justified.
- §8: a script in kebab-case is never imported; a script named in `snake_case` is imported somewhere.
