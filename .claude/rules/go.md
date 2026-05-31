---
applyTo: "**/*.go"
description: Go file conventions
globs: ["**/*.go"]
paths: ["**/*.go"]
---

# Go

## Comments

- Add GoDoc comments to every exported identifier (functions, types, variables, constants).
- Use `doc.go` files when creating package-level documentation.

### Example

Single-line (most identifiers):

```go
// FunctionName does something with input and returns result.
func FunctionName(input string) (string, error) { ... }

// TypeName represents something.
type TypeName struct { ... }
```

Multiline (when additional context is needed - separate paragraphs with `//`):

```go
// FunctionName does something with input and returns result.
//
// It also handles the edge case where input is empty.
// In that case, it returns an error.
func FunctionName(input string) (string, error) { ... }
```

`doc.go` (package-level documentation):

```go
/*
Package mypkg provides utilities for doing something.

Optional additional paragraphs describing the package further.

Example:

  func main() {
    result, err := mypkg.FunctionName("input")
    // handle err
  }
*/
package mypkg
```

## Context

- `context.Context` is always the first parameter (after the receiver) and named `ctx`.

## Declarations

- Use `:=` for local variables. Reserve `var` for zero values, package-level declarations, and interface compliance checks.
- Avoid named return values.
- Avoid global `var` declarations unless explicitly required.
- Avoid `init()`. Use constructor functions instead.

## Errors

- Wrap with `fmt.Errorf("small context information: %w", err)`. Never swallow errors.
- Declare `var ErrFoo = errors.New("...")` only when a caller must use `errors.Is` / `errors.As`.
- Error strings: short, lowercase, no trailing punctuation.
- Aggregate multiple errors with `errors.Join(errs...)`.

## Interfaces

- Use concrete types by default. Define an interface only when two or more distinct implementations exist.
- Verify compliance at compile time: `var _ MyInterface = (*MyType)(nil) // ensure interface is implemented`

## Linting

- Use targeted `//nolint:rulename` directives. Never use bare `//nolint`.

## Optimizations

- Pre-allocate slices and maps when the final size is known: `make([]T, 0, n)` and `make(map[K]V, n)`.
- When the size is unknown before the loop, declare without capacity (`var s []T`); add `//nolint:prealloc` only when golangci-lint flags it.
- Use `strings.Builder` or `bytes.Buffer` to assemble strings; never concatenate with `+` inside a loop.
- Prefer `slices.*` and `maps.*` (stdlib, Go 1.21+) over manual for-range implementations.
- Use index-only range (`for i := range s`) when the element value is not needed to avoid an implicit copy.

## Receivers

- Use a pointer receiver when the method mutates state or the type is large.
- Keep receivers consistent within a type.

## Libraries

### Cobra CLI

- Place CLI code under a dedicated package (e.g., `internal/cobra/`); one file per command with a matching `_test.go`.
- Name constructors `{name}Cmd() *cobra.Command`; pass shared state as parameters, not globals.
- Wire subcommands in a single top-level `Execute()` function.
- Always use `RunE` instead of `Run`.
- Set `SilenceErrors: true` and `SilenceUsage: true` on the root command; handle errors and usage printing manually.
- Use `PersistentPreRunE` for cross-cutting setup (logger, working directory); `PreRunE` for command-specific validation.
- Use `PersistentFlags()` for flags inherited by all subcommands; `Flags()` for command-local flags.
- Enforce flag constraints with `MarkFlagRequired()` and the related `MarkFlags*` methods.
- Store flag names as package-level constants for reuse across files and tests.
- Do not introduce `viper`. Implement local helpers like `getenv()` and `coalesce()`.
  - `getenv` maps a kebab-case flag name to its `SCREAMING_SNAKE_CASE` env var
  - `coalesce` returns the first non-empty string. Use `coalesce(getenv(flagName), hardcodedDefault)` as the flag default.

#### Example

```go
func Execute() {
	root := rootCmd()
	root.AddCommand(fooCmd())

	if err := root.Execute(); err != nil {
		subcmd, _, _ := root.Find(os.Args[1:])
		usage(root, subcmd, err) // print cmd usage for unknown flag / command errors
		os.Exit(1) //nolint:revive
	}
}

func rootCmd() *cobra.Command {
	logLevel := "info"
	cmd := &cobra.Command{ /* ... */ }
	cmd.PersistentFlags().StringVar(&logLevel, flagLogLevel, coalesce(getenv(flagLogLevel), logLevel), "set logging level")
	return cmd
}
```
