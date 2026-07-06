---
applyTo: "**/*_test.go"
description: Go test file conventions
globs: ["**/*_test.go"]
paths: ["**/*_test.go"]
---

# Go tests

## Package naming

- Always use the external test package: `package foo_test`.
- Use `package foo` only when the project already does so (check existing test files first).
- When a directory has both styles, match the file being extended; for new standalone test files default to `package foo_test`.

## Structure

- Use `t.Run("description", func(t *testing.T) { ... })` subtests for each test case.
- No table-driven tests (struct slice + range) unless explicitly asked.
- Use `t.Cleanup(fn)` for teardown and state restoration; prefer it over `defer` in subtests.
- Use `t.TempDir()` for file I/O - it is cleaned up automatically.
- Mark test helpers with `t.Helper()` as their first statement.

## Assertions

- Match the project's existing test library.
- If no library is present, use stdlib `testing` only.
- Use `require.` (or equivalent failing-fast assertions) for preconditions; `assert.` for the actual assertions.

## Stdlib example

```go
package mypackage_test

import (
  "errors"
  "testing"
)

func TestDoSomething(t *testing.T) {
  t.Run("returns error on invalid input", func(t *testing.T) {
    // Arrange
    input := ""

    // Act
    err := mypackage.DoSomething(input)

    // Assert
    if !errors.Is(err, mypackage.ErrInvalidInput) {
      t.Fatalf("expected ErrInvalidInput, got %v", err)
    }
  })
}
```

## Testify example

```go
package files_test

import (
  "os"
  "path/filepath"
  "testing"

  "github.com/stretchr/testify/assert"
  "github.com/stretchr/testify/require"
)

func TestReadJSON(t *testing.T) {
  t.Run("invalid json returns error", func(t *testing.T) {
    // Arrange
    path := filepath.Join(t.TempDir(), "bad.json")
    require.NoError(t, os.WriteFile(path, []byte("{invalid}"), 0o644))

    // Act
    var result map[string]any
    err := files.ReadJSON(path, &result)

    // Assert
    assert.ErrorContains(t, err, "unmarshal")
  })
}
```
