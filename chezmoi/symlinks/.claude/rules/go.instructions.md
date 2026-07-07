---
applyTo: "**/*.go"
description: Go file conventions
globs: ["**/*.go"]
paths: ["**/*.go"]
---
# Go

## Comments

- Add GoDoc comments every exported identifier (functions, types, variables, constants).
- Use `doc.go` files for package-level docs.

### Example

Single-line (most identifiers):

```go
// FunctionName does something with input and returns result.
func FunctionName(input string) (string, error) { ... }

// TypeName represents something.
type TypeName struct { ... }
```

Multiline (when extra context needed - separate paragraphs with `//`):

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

- `context.Context` always first param (after receiver), named `ctx`.

## Declarations

- Use `:=` local vars. Reserve `var` for zero values, package-level decls, interface compliance checks.
- Avoid named return values.
- Avoid global `var` decls unless explicit required.
- Avoid `init()`. Use constructor functions instead.

## Errors

- Wrap `fmt.Errorf("small context information: %w", err)`. Never swallow errors.
- Declare `var ErrFoo = errors.New("...")` only when caller must use `errors.Is` / `errors.As`.
- Error strings: short, lowercase, no trailing punctuation.
- Aggregate multiple errors `errors.Join(errs...)`.

## Interfaces

- Use concrete types default. Define interface only when two+ distinct implementations exist.
- Verify compliance compile time: `var _ MyInterface = (*MyType)(nil) // ensure interface is implemented`

## Linting

- Use targeted `//nolint:rulename` directives. Never bare `//nolint`.

## Optimizations

- Pre-allocate slices/maps when final size known: `make([]T, 0, n)` and `make(map[K]V, n)`.
- Size unknown before loop → declare without capacity (`var s []T`); add `//nolint:prealloc` only when golangci-lint flags it.
- Use `strings.Builder` or `bytes.Buffer` assemble strings; never concat `+` inside loop.
- Prefer `slices.*` and `maps.*` (stdlib, Go 1.21+) over manual for-range implementations.
- Use index-only range (`for i := range s`) when element value not needed — avoids implicit copy.

## Receivers

- Pointer receiver when method mutates state or type large.
- Keep receivers consistent within type.

## Libraries

### Cobra CLI

- Place CLI code under dedicated package (e.g., `internal/cobra/`); one file per command + matching `_test.go`.
- Name constructors `{name}Cmd() *cobra.Command`; pass shared state as params, not globals.
- Wire subcommands single top-level `Execute()` function.
- Always use `RunE` instead of `Run`.
- Set `SilenceErrors: true` and `SilenceUsage: true` on root command; handle errors/usage printing manual.
- Use `PersistentPreRunE` for cross-cutting setup (logger, working directory); `PreRunE` for command-specific validation.
- Use `PersistentFlags()` for flags inherited by all subcommands; `Flags()` for command-local flags.
- Enforce flag constraints with `MarkFlagRequired()` and related `MarkFlags*` methods.
- Store flag names as package-level constants, reuse across files/tests.
- No `viper`. Implement local helpers like `getenv()` and `coalesce()`.
  - `getenv` maps kebab-case flag name to `SCREAMING_SNAKE_CASE` env var
  - `coalesce` returns first non-empty string. Use `coalesce(getenv(flagName), hardcodedDefault)` as flag default.

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
