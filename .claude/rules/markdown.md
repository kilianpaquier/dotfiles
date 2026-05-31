---
applyTo: "**/*.md"
description: Markdown file conventions
globs: ["**/*.md"]
paths: ["**/*.md"]
---

# Markdown

## Structure

- One `#` heading per document.
- Do not skip heading levels (e.g. `##` directly under `#`, not `###`).
- Blank line before and after every heading, code block, list, and table.

## Lists

- Use `-` for unordered list items, not `*` or `+`.
- Use `1.` for ordered lists.

## Code blocks

- Always specify the language in fenced code blocks:
  ```sh
  echo hello
  ```

## Tables

- Align column separators (`|`) vertically.
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
