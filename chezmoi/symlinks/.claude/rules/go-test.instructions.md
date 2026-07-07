---
applyTo: "**/*_test.go"
description: Go test file conventions
globs: ["**/*_test.go"]
paths: ["**/*_test.go"]
---
# Go tests

## Package naming

- Always use external test package: `package foo_test`.
- Use `package foo` only when project already does so (check existing test files first).
- Directory has both styles → match file being extended; new standalone test files default `package foo_test`.

## Structure

- Use `t.Run("description", func(t *testing.T) { ... })` subtests each test case.
- No table-driven tests (struct slice + range) unless explicit ask.
- Use `t.Cleanup(fn)` teardown, state restore; prefer over `defer` in subtests.
- Use `t.TempDir()` file I/O - cleaned up auto.
- Mark test helpers `t.Helper()` first statement.

## Assertions

- Match project's existing test library.
- No library present → stdlib `testing` only.
- Use `require.` (or equivalent fail-fast assertions) preconditions; `assert.` actual assertions.

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
