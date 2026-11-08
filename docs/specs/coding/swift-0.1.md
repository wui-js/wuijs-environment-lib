# Swift

General rules for Swift source files (`.swift`).

## 1. Indentation

- Indentation uses one tab `\t` per nesting level.
- A statement split over several lines indents its continuation lines one level deeper than the statement.

---

## 2. Line breaks

- One blank line after the file header when one exists and after the `import` block.
- One blank line at the start of a type body, between groups of properties and between members (initializers, methods,
  nested types).
- No blank lines between declarations of the same group of properties.
- No blank lines inside initializer, method and closure bodies.
- No line made only of spaces or tabs, no trailing whitespace, never two consecutive blank lines.

---

## 3. Braces and statements

- The opening brace goes at the end of the line that opens the block, never on its own line.
- One statement per line.
- An early exit may stay on one line: `guard let self = self else { return }`.
- In a `switch`, each `case` is indented one level inside the `switch`.

```swift
// correct
switch type {
	case "camera":
		openCamera()
	default:
		break
}
```

---

## 4. Naming

- Types and protocols in PascalCase. Properties, methods, parameters, local constants and variables in camelCase.
- Identifiers in English.
- Acronyms (`JSON`, `HTML`, `URL`, `HTTP`, `ID`, `UUID`) are written in forced camelCase inside the project's own
  identifiers: only the first letter in uppercase (`deepLinkUrl`, `requestUrl`, `tempUrl`). A type name keeps a full
  uppercase acronym only as its first word (`WUIEnvironment`). Names that come from the platform API keep their form
  (`URL`, `forHTTPHeaderField:`).
- Words are split as they are written in English: a term written as two words takes one capital per word (`deepLink`,
  not `deeplink`); a term established as a single word stays one word (`timestamp`, `username`, not `timeStamp`,
  `userName`).

```swift
// correct
private var deepLinkUrl: String? = nil

// incorrect
private var deepLinkURL: String? = nil
```

---

## 5. Method naming

- A method is named `{verb}()` or `{verb}{Noun}()` (`getAppInfo()`, `setupUserAgent()`, `initWebView()`), never
  `{noun}{Verb}()` (`webViewInit()`).
- A method that reacts to an event or a result is named `on{Event}()`. Delegate methods keep the names the platform
  protocol defines.
- A closure or nested function keeps a simple name in the context of its method (`read`, `finish`) and never repeats the
  method's name.

---

## 6. Declarations

- `let` for every value that is not reassigned; `var` only when the value changes.
- Members that are internal to the type are `private`.
- The type annotation is written only when inference does not give the intended type.
- Implicitly unwrapped optionals (`WKWebView!`) only for properties that are assigned during initialization.

---

## 7. Optionals and closures

- Optionals are unwrapped with `if let`, `guard let` or `??`. Force unwrapping (`value!`) is not used, except for values
  that cannot be `nil` by construction.
- An escaping closure that uses `self` captures it weakly (`[weak self]`) and unwraps it at the start with `guard let
  self = self else { return }`.

```swift
// correct
webView.evaluateJavaScript(script) { [weak self] result, _ in
	guard let self = self else { return }
	self.handleResult(result)
}
```

---

## 8. Strings

Strings are built with interpolation (`"\(name)/\(version)"`), not with `+`.

---

## 9. Comments

- Comments follow `specs-0.1.md` §8. The label is a single line over a group of members: `// MARK: - Initialization`.
- Attributes addressed to the compiler (`@objc`, `@unchecked Sendable`) are not comments and are allowed.
- No commented-out code.

---

## 10. Organization and parity

- Each protocol conformance is declared in its own `extension {Type}: {Protocol}`, after the type body, in the order the
  type adopts them.
- A type that has a counterpart in another platform language (e.g. the same bridge implemented in Swift and Java) keeps
  the same public method names, the same parameters and the same results in both.

---

## Verification

Empty output means no violations, except where a comment says the output is a list for review.

```bash
# §1 — indentation with spaces
grep -rnE "^ {2,}[^ *]" {scope} --include="*.swift"

# §2 — lines made of whitespace, trailing whitespace, two consecutive blank lines
grep -rnE "^[[:space:]]+$|[^[:space:]][[:space:]]+$" {scope} --include="*.swift"
find {scope} -name "*.swift" -exec awk '/^$/ && p ~ /^$/ {print FILENAME":"FNR} {p=$0}' {} +

# §3 — opening braces on their own line
grep -rnE "^[[:space:]]*\{[[:space:]]*$" {scope} --include="*.swift"

# §4 — identifiers with uppercase acronyms (review: platform API names are valid)
grep -rnoE "\b(let|var|func) [a-z]+[A-Za-z]*[A-Z]{2,}[A-Za-z0-9]*" {scope} --include="*.swift"

# §7 — force unwrapping (review: valid only when nil is impossible by construction)
grep -rnE "[]A-Za-z0-9_)]!\.|[]A-Za-z0-9_)]! *$" {scope} --include="*.swift"

# §8 — string concatenation
grep -rnE "\" *\+|\+ *\"" {scope} --include="*.swift"

# §9 — comments (review: only single-line labels)
grep -rnE "^[[:space:]]*//" {scope} --include="*.swift" | grep -v "// MARK: - "
```

## Manual review

- §2: no blank lines inside initializer, method and closure bodies.
- §4: acronyms in camelCase and words split as written in English (`deepLink`, `timestamp`).
- §5: method names follow `{verb}{Noun}()` or `on{Event}()`.
- §6: values not reassigned are `let`; internal members are `private`.
- §7: escaping closures that use `self` capture it weakly.
- §9: comments label, never explain; no commented-out code.
- §10: public names, parameters and results match the counterpart in the other platform.
