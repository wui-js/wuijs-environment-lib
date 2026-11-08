# JS

General rules for JavaScript. They apply to every `.js` file in the project scope. A `js-{use}` spec extends or
restricts them for one kind of file; the file header, when a kind of file has one, is defined by its use spec.

## 1. Indentation

Indentation uses the tab character `\t`.

---

## 2. Line breaks

- The separator is **a single blank line, never two or more in a row**, anywhere in the file.
- A blank line after the header, when the file has one.
- A blank line at the start of a class body.
- No blank lines between declarations of the same section: consecutive static fields, consecutive private instance
  fields, consecutive constants of the same group.
- A blank line between sections (for example, static fields and instance fields) and between members: constructor,
  getters, setters and methods.
- No blank lines inside a body: constructor, getter, setter, method or function.
- Class names, constructors, getters, setters and methods start on their own line.

```js
// correct
class UIExample {

	static #path = "/api/example";
	static #active = null;

	static #htmlElements = {
		version: document.querySelector("#exampleForm .version")
	};

	static init() {
		const x = 1;
		const y = 2;
		return x + y;
	}

	static reset() {
		this.#active = null;
	}
}

// incorrect
class UIExample {
	static #path = "/api/example";

	static #active = null;
	static init() {
		const x = 1;

		return x;
	}
	static reset() { this.#active = null; }
}
```

---

## 3. Identifier naming

Identifiers (variables, parameters, functions, methods, properties) are in English and in camelCase. Classes are in
PascalCase.

```js
// correct
const selectedCount = options.querySelectorAll(".option.selected").length;

// incorrect
const cantidadSeleccionados = options.querySelectorAll(".option.selected").length;
```

### 3.1. Acronyms

Acronyms (`JSON`, `HTML`, `CSS`, `URL`, `XML`, `HTTP`, `DOM`, `SVG`, `ID`, `API`, `UUID`, `URI`, ...) inside properties,
constants, variables, functions and methods, public or private, are written in forced camelCase: only the first letter
in uppercase, the rest in lowercase.

This rule does not apply to class names in one case: a class name keeps an acronym fully in uppercase only when it is
the first word of the name (`WUIButton`, `UIHome`). In any other position of a class name, the acronym is also forced to
camelCase.

```js
// correct
responseJson()
#loadHtml()
static validateUrl(url) { ... }
class WUIButton { ... }
class WUIPluginFormHttp { ... }

// incorrect
responseJSON()
#loadHTML()
static validateURL(url) { ... }
class WUIPluginFormHTTP { ... }
```

### 3.2. Word boundaries

Words are split as they are written in English: a term written as two words takes one capital per word. A term
established in English as a single word stays one word, however it could be decomposed.

Combined with §3.1, an acronym inside a compound name is one more word: `deepLinkUrl` (deep + link + URL).

```js
// correct
const deepLink = parseDeepLink(url);
const deepLinkUrl = deepLink.url;
const timestamp = Date.now();
const username = form.username.value;
const checkbox = form.querySelector("input[type=checkbox]");

// incorrect: a two-word term written as one
const deeplink = parseDeepLink(url);
const deeplinkUrl = deeplink.url;

// incorrect: a one-word term split in two
const timeStamp = Date.now();
const userName = form.userName.value;
const checkBox = form.querySelector("input[type=checkbox]");
```

---

## 4. Function and method naming

### 4.1. `{verb}()` or `{verb}{Noun}()`

Every function and method, public or private, starts with a verb that names the action. The noun, when there is one,
comes after the verb, never before.

```js
// correct
static getProperty(name) { ... }
static setLang(lang, onLoad) { ... }
static goPage(target) { ... }
static goBack() { ... }
static #signinProvider(provider) { ... }

// incorrect: noun before the verb
static #providerSignin(provider) { ... }

// incorrect: not a verb
static back() { ... }

// incorrect: verb and particle fused, not verb + noun
static signout() { ... }
```

Getters and setters are named after the property they expose; this rule does not apply to them.

A public method published before the project adopted this spec keeps its name when renaming it would force changes in
its consumers. The project lists each such name as an exception in its `CODING.md`. New methods and every private method
follow the rule.

### 4.2. `on{Event}` for reactions

A function or method is named `on{Event}` when it reacts to something that already happened: the result of an
asynchronous operation, a component callback, the end of an external process. It does not take the `on` prefix when the
code itself decides and orders the action. This is the only exception to §4.1: `{Event}` is not a noun the method
operates on, but the result that triggers the reaction.

```js
// correct: reacts to the end of the composition
body: new WUIBody({ onCompleted: () => { this.#onReady(); } })
static #onReady() { ... }

// correct: reacts to the result of a submit already sent
static #onSuccess(data) { ... }
static #onInvalid(validations) { ... }

// correct: an action the code orders, without "on"
static async #submit() { ... }
static #validate(values) { ... }
```

### 4.3. Inner functions

A function declared inside a method or another function (`const name = () => { ... }`) follows §4.1 and §4.2. Its name
is already scoped by the function that contains it, so it stays simple and never repeats the name of its parent.

```js
// correct
static #openMessage(type) {
	const onClose = () => { form.validation.focusFirstInput(); };
	...
}

static #loadOptions(options) {
	const addOption = option => { ... };
	options.forEach(addOption);
}

// incorrect: repeats the parent's name
static #openMessage(type) {
	const onOpenMessageClose = () => { ... };
	...
}

static #loadOptions(options) {
	const loadOptionsAdd = option => { ... };
	...
}
```

---

## 5. Declarations

- `const` for every variable that is not reassigned.
- `let` only when the value changes after the declaration.
- `var` is not used.

Declarations go at the start of the block, or as soon as the dependencies that build them are available, in this order:

1. `const` values.
2. `const` functions.
3. `let` values.

```js
// correct
const { form } = this.#wuiComponents;
const onClose = () => { form.validation.focusFirstInput(); };
let validations = [];

// incorrect: let before const, function mixed in
let validations = [];
const onClose = () => { form.validation.focusFirstInput(); };
const { form } = this.#wuiComponents;
```

When a declaration depends on another, it goes right after the one it needs, keeping the internal order of each group.

```js
// correct: endValue depends on iniValue
const iniValue = parseInt(input.value);
let endValue = iniValue + parseInt(dragDiffX / 40);
```

---

## 6. Strict comparisons

Always `===` and `!==`, never `==` and `!=`.

```js
// correct
if (input.getAttribute("style") !== null) { ... }
if (callback === null) { ... }

// incorrect
if (status == "success") { ... }
if (callback == null) { ... }
```

### 6.1. `typeof`

`typeof` is written with its operand in parentheses: `typeof (value)`.

```js
// correct
if (typeof (value) === "string") { ... }

// incorrect
if (typeof value === "string") { ... }
```

---

## 7. Callbacks without wrappers

A callback that can be passed directly is not wrapped in an intermediate function.

```js
// correct
mediaQuery.addEventListener("change", callback);
mediaQuery.removeEventListener("change", callback);

// incorrect
const onChange = () => { callback(); };
mediaQuery.addEventListener("change", onChange);
mediaQuery.removeEventListener("change", onChange);
```

---

## 8. Conditional classes

A class that depends on a condition is set with `classList.toggle()` and the condition as its second argument, never
with an `if`/`else` or a ternary that calls `add()` and `remove()`.

```js
// correct
element.classList.toggle("selected", isSelected);

// incorrect
if (isSelected) {
	element.classList.add("selected");
} else {
	element.classList.remove("selected");
}

// incorrect
isSelected ? element.classList.add("selected") : element.classList.remove("selected");
```

---

## Verification

```bash
# §1 — indentation with spaces
grep -rnE "^( {2}| {4})" {scope} --include="*.js"

# §2 — two or more consecutive blank lines
find {scope} -name "*.js" | xargs awk 'FNR==1{b=0} /^[ \t]*$/{if(b){print FILENAME":"FNR}; b=1; next} {b=0}'

# §5 — var
grep -rnE "(^|[^[:alnum:]_.])var[[:space:]]+[A-Za-z_$]" {scope} --include="*.js"

# §6 — non-strict comparisons
grep -rnE "[^=!<>]==[^=]|[^!]!=[^=]" {scope} --include="*.js"

# §6.1 — typeof without parentheses
grep -rnE "(^|[^[:alnum:]_])typeof[[:space:]]+[^([:space:]]" {scope} --include="*.js"

# §8 — add()/remove() of the same class in the branches of one if/else or ternary
find {scope} -name "*.js" | xargs awk 'FNR==1{p1=p2=p3=""} match($0,/classList\.(add|remove)\("[^"]+"\)/){s=substr($0,RSTART,RLENGTH); t=s; sub(/classList\.(add|remove)/,"",t); t="classList." (s ~ /\.add/ ? "remove" : "add") t; w=p1 "\n" p2 "\n" p3; if ((index(w,t) && w ~ /}[[:space:]]*else[[:space:]]*\{/) || (index($0,t) && $0 ~ /\?/)) print FILENAME":"FNR} {p3=p2; p2=p1; p1=$0}'
```

## Manual review

- §2: blank lines between sections and members, and none inside bodies.
- §3, §3.1 and §3.2: identifier, acronym and word-boundary forms.
- §4: the verb names what the method does; `on{Event}` is a reaction and not an ordered action; inner functions do not
  repeat their parent's name.
- §5: declaration order inside each block.
- §7: callbacks wrapped without need.
- §8: conditional classes set with `if`/`else` whose `add()` and `remove()` are more than 3 lines apart, or with variable class names. An `else if` chain with more than two outcomes is not a violation.
