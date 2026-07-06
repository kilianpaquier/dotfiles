---
applyTo: "**/*.ts,**/*.tsx,**/*.js"
description: TypeScript / JavaScript conventions
globs: ["**/*.ts", "**/*.tsx", "**/*.js"]
paths: ["**/*.ts", "**/*.tsx", "**/*.js"]
---

# TypeScript / JavaScript

## Functions & exports

- Exported functions: arrow functions (`export const fn = (...) => { }`).
- Named exports only - no default exports.
- File names: `kebab-case`.

## Types

- `interface` for public contracts (objects, class shapes).
- `type` for aliases and unions.
- Enum values: SCREAMING_SNAKE_CASE strings.

## Errors

- Always throw errors, never return them as values.

## Imports

- Sort imports alphabetically within each group (enforced by ESLint `sort-imports`).
- No default imports from local modules.

## Comments

- Add JSDoc to every exported function (parameters, return type, thrown errors).

### Example

```typescript
/**
 * functionName does something with the given input.
 *
 * @param param1 description of param1.
 * @param param2 description of param2.
 *
 * @returns the computed result.
 *
 * @throws an error if something goes wrong.
 */
export const functionName = (param1: string, param2: number): string => { ... }
```

## Tests

- Framework: match the project (Bun test, Jest, Vitest, etc.).
- File pattern: `*.test.ts`.
- Structure: `describe` + `test`.
- Mocks: `spyOn` + framework teardown in `afterEach` (e.g. `mock.restore()` for Bun, `jest.restoreAllMocks()` for Jest, `vi.restoreAllMocks()` for Vitest).

### Example

```typescript
describe("myFunction", () => {
  afterEach(() => restoreMocks()) // framework-specific teardown

  test("should return processed value", () => {
    // Arrange
    spyOn(dep, "fetch").mockResolvedValue({ ok: true, data: "raw" })

    // Act
    const result = myFunction("input")

    // Assert
    expect(result).toEqual("processed")
  })
})
```
