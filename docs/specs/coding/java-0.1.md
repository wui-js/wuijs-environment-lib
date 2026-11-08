# Java

General rules for Java source files (`.java`).

## 1. Indentation

- Indentation uses one tab `\t` per nesting level.
- A statement split over several lines indents its continuation lines one level deeper than the statement.

```java
// correct
Uri[] results = resultCode == Activity.RESULT_OK && data != null
	? new Uri[]{ data.getData() } : null;
```

---

## 2. Line breaks

- One blank line after the file header when one exists, after `package` and after the `import` block.
- One blank line at the start of a class body, between groups of fields and between members (constructors, methods,
  nested classes).
- No blank lines between declarations of the same group of fields.
- No blank lines inside constructor and method bodies.
- No line made only of spaces or tabs, no trailing whitespace, never two consecutive blank lines.

---

## 3. Braces and statements

- The opening brace goes at the end of the line that opens the block, never on its own line.
- One statement per line.
- A block with a single statement keeps its braces, except an early exit written on one line: `if (callback == null)
  return;`.
- In a `switch`, each `case` is indented one level inside the `switch`. A `case` whose only statement is followed by
  `break` may stay on one line.

```java
// correct
switch (type) {
	case "camera":
		openCamera();
		break;
	case "files": openFiles(); break;
}

// incorrect
if (callback == null)
	return;
```

---

## 4. Naming

- Classes, interfaces and enums in PascalCase. Methods, fields, parameters and local variables in camelCase. Constants
  (`static final` with an immutable value) in UPPER_SNAKE_CASE.
- Identifiers in English.
- Acronyms (`JSON`, `HTML`, `URL`, `HTTP`, `ID`, `UUID`, `SSL`) are written in forced camelCase inside identifiers: only
  the first letter in uppercase (`deepLinkUrl`, `getJsonObject()`, `requestUrl`). A class name keeps a full uppercase
  acronym only as its first word (`WUIEnvironment`). Names that come from the platform API keep their form.
- Words are split as they are written in English: a term written as two words takes one capital per word (`deepLink`,
  not `deeplink`); a term established as a single word stays one word (`timestamp`, `username`, not `timeStamp`,
  `userName`).

```java
// correct
private String deepLinkUrl = null;
private static final int REQUEST_CODE_BASE = 1000;

// incorrect
private String deepLinkURL = null;
```

---

## 5. Method naming

- A method is named `{verb}()` or `{verb}{Noun}()` (`load()`, `getAppInfo()`, `setupWebViewClient()`, `initWebView()`),
  never `{noun}{Verb}()` (`webViewInit()`).
- A method that reacts to an event or a result is named `on{Event}()` (`onPageLoaded()`).
- A lambda or local helper keeps a simple name in the context of its method and never repeats the method's name.

---

## 6. Declarations and imports

- A field or local variable that is assigned once is `final`.
- Every type is imported explicitly. No wildcard imports (`import java.util.*;`) and no fully qualified names in the
  code (`new java.util.HashSet<>()`), except to resolve a name collision.
- Imports are grouped by root (`android`, `androidx`, `java`, third parties) and sorted inside each group.

---

## 7. Comparisons

- `==` and `!=` only for primitives, enums and `null`.
- Objects and strings are compared with `equals()`; `Objects.equals(a, b)` when either side may be `null`.

```java
// correct
if ("camera".equals(type)) { ... }

// incorrect
if (type == "camera") { ... }
```

---

## 8. Strings

String concatenation has one space on each side of `+`: `"name: " + name`, never `"name: "+name`.

---

## 9. Comments

- Comments follow `specs-0.1.md` §8. The label is a single line over a group of members or a block (`// Initialization`,
  `// Native bridge functions`).
- Annotations addressed to a tool (`@SuppressLint(...)`, `@Override`) are not comments and are allowed.
- No commented-out code.

---

## 10. Cross-platform parity

A class that has a counterpart in another platform language (e.g. the same bridge implemented in Java and Swift) keeps
the same public method names, the same parameters and the same results in both, so callers use one contract.

---

## Verification

Empty output means no violations, except where a comment says the output is a list for review.

```bash
# §1 — indentation with spaces
grep -rnE "^ {2,}[^ *]" {scope} --include="*.java"

# §2 — lines made of whitespace, trailing whitespace, two consecutive blank lines
grep -rnE "^[[:space:]]+$|[^[:space:]][[:space:]]+$" {scope} --include="*.java"
find {scope} -name "*.java" -exec awk '/^$/ && p ~ /^$/ {print FILENAME":"FNR} {p=$0}' {} +

# §3 — opening braces on their own line
grep -rnE "^[[:space:]]*\{[[:space:]]*$" {scope} --include="*.java"

# §4 — identifiers with uppercase acronyms (review: platform API names are valid)
grep -rnoE "\b[a-z]+[A-Za-z]*[A-Z]{2,}[a-z0-9]*[A-Za-z]*\b" {scope} --include="*.java" | grep -vE ":[A-Z_]+$"

# §6 — wildcard imports and fully qualified names in the code
grep -rnE "^import .*\*;|(new|<|\(|, ) *java\.[a-z]+\.[A-Z]" {scope} --include="*.java"

# §7 — strings compared with == or !=
grep -rnE "(==|!=) *\"|\" *(==|!=)" {scope} --include="*.java"

# §8 — concatenation without spaces
grep -rnE "\"\+|\+\"" {scope} --include="*.java"

# §9 — comments (review: only single-line labels)
find {scope} -name "*.java" | xargs awk 'FNR==1{h=($0 ~ /^[[:space:]]*\/\*/)} h{if($0 ~ /\*\//)h=0; next} /^[[:space:]]*(\/\/|\/\*)/{print FILENAME":"FNR}'
```

## Manual review

- §2: no blank lines inside constructor and method bodies.
- §4: acronyms in camelCase and words split as written in English (`deepLink`, `timestamp`).
- §5: method names follow `{verb}{Noun}()` or `on{Event}()`.
- §6: fields and variables assigned once are `final`.
- §9: comments label, never explain; no commented-out code.
- §10: public names, parameters and results match the counterpart in the other platform.
