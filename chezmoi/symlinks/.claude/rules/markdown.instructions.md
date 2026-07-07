---
applyTo: "**/*.md"
description: Markdown file conventions
globs: ["**/*.md"]
paths: ["**/*.md"]
---
# Markdown

## Structure

- One `#` heading per doc.
- No skip heading levels (e.g. `##` direct under `#`, not `###`).
- Blank line before, after every heading, code block, list, table.

## Lists

- Use `-` unordered items, not `*` or `+`.
- Use `1.` ordered lists.

## Code blocks

- Always specify language fenced code blocks:
```sh
echo hello
```

## Tables

- Align column separators (`|`) vertically (do not use any language for this action).
- Pad cell content with spaces to align columns.
- Header separator row: use `-` repeated to match the column width.

Example:

| Column A     | Column B                  |
| ------------ | ------------------------- |
| short        | a longer value            |
| longer value | another value             |

## Links

- Inline links: `[text](url)`.
- No bare URLs in prose - wrap them in angle brackets (`<url>`) or use inline link syntax.
