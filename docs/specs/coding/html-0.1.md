# HTML

General rules for HTML files: complete documents (`.html`) and fragments that are inserted into a document (`.htm`).

## 1. Indentation

Indentation uses one tab `\t` per nesting level. Every element is indented one level deeper than its parent, including
`<head>` and `<body>` inside `<html>`.

```html
<!-- correct -->
<html>
	<head>
		<title></title>
	</head>
	<body>
		<section id="mainSection"></section>
	</body>
</html>
```

---

## 2. Line breaks

- One element per line. An element whose only content is text or nothing stays on one line (`<div
  class="output"></div>`, `<title>Home</title>`).
- No blank lines between elements, including the start and the end of `<head>` and `<body>`.
- Never two consecutive blank lines.

---

## 3. Document structure

A complete document starts with `<!DOCTYPE html>` and has `<html>`, `<head>` and `<body>`.

Inside `<head>`, in this order:
1. `<title>`.
2. `<meta>`: `charset` first, then `viewport` and the rest.
3. `<link>`: icons first, then style sheets in load order (libraries before the document's own sheets).
4. External `<script>` in load order (libraries before the document's own scripts).

Inside `<body>`, the containers come first, then the external `<script>` elements and, at the end, an inline `<script>`
when the document needs one to start its code.

A fragment (`.htm`) has no `<!DOCTYPE>`, `<html>`, `<head>` or `<body>`: its root is the element it provides, at
indentation level zero.

---

## 4. Elements and attributes

- Element and attribute names in lowercase.
- Attribute values in double quotes.
- Void elements without a closing slash: `<meta charset="utf-8">`, `<input type="text">`, never `<br/>`.
- Boolean attributes without a value: `novalidate`, `disabled`.
- `<link>` attributes in the order `type`, `rel`, `href`; external `<script>` in the order `type`, `src`, with
  `type="text/javascript"`. An inline `<script>` has no attributes.

```html
<!-- correct -->
<link type="text/css" rel="stylesheet" href="/styles/app.css">
<script type="text/javascript" src="/scripts/app.js"></script>

<!-- incorrect -->
<link rel="stylesheet" href='/styles/app.css' />
<script src="/scripts/app.js" type="text/javascript"></script>
```

---

## 5. Naming

- `id` in camelCase and in English, ending with the role of the element: `Section`, `Form`, `Fieldset`, `Modal`, `Page`,
  `Panel`, `View` (`loadSection`, `profilePermissionsForm`, `messageModal`).
- `name` in camelCase and in English (`name="profilePermissions"`).
- `class` in kebab-case and in English (`class="wui-list permissions"`, `class="output number-formatting"`).

---

## 6. Separation of concerns

- No `style` attributes: styles live in style sheets.
- No inline event attributes (`onclick`, `onload`, ...): listeners are registered from JavaScript. Attributes that a
  library generates at run time from its own configuration are outside this rule.
- No HTML comments. A container is identified by its `id` and `class`, not by a comment.

---

## Verification

Empty output means no violations.

```bash
# §1 — indentation with spaces
grep -rnE "^( {2}| {4})<" {scope} --include="*.html" --include="*.htm"

# §1 — <head> or <body> not indented inside <html>
grep -rnE "^</?(head|body)[ >]" {scope} --include="*.html"

# §2 — blank line right after <head> or <body>, or right before their closing tag
find {scope} -name "*.html" -exec awk 'p ~ /<(head|body)[ >]/ && /^[ \t]*$/ || /<\/(head|body)>/ && p ~ /^[ \t]*$/ {print FILENAME":"FNR} {p=$0}' {} +

# §4 — uppercase tags, single quotes, self-closing void elements
grep -rnE "<[A-Z]+[ >]|<[a-z]+ [^>]*=[ ]*'[^']*'|<(meta|link|input|br|img|hr)[^>]*/>" {scope} --include="*.html" --include="*.htm"

# §4 — attribute order in <link> and external <script>
grep -rnE "<link (rel|href)=|<script (src)=" {scope} --include="*.html" --include="*.htm"

# §5 — kebab-case or snake_case ids, camelCase classes
grep -rnE " id=\"[a-z]+[-_]|class=\"[^\"]*[a-z][A-Z]" {scope} --include="*.html" --include="*.htm"

# §6 — style attributes, inline event attributes, comments
grep -rnE " style=\"| on[a-z]+=\"|<!--" {scope} --include="*.html" --include="*.htm"
```

## Manual review

- §2: one element per line; elements with text or no content stay on one line.
- §3: order of the `<head>` children and of the `<body>` scripts.
- §5: each `id` ends with the role of its element.
