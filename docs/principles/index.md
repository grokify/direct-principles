# DIRECT Principles Overview

The six DIRECT principles form a comprehensive framework for designing agent-friendly interfaces.

## The Acronym

**D.I.R.E.C.T.** stands for:

| Letter | Principle | One-Line Summary |
|--------|-----------|------------------|
| **D** | [Deterministic](deterministic.md) | Same input always produces same output shape |
| **I** | [Introspectable](introspectable.md) | Machine-readable capabilities and schemas |
| **R** | [Recoverable](recoverable.md) | Structured errors enable automated correction |
| **E** | [Explicit](explicit.md) | All constraints declared in specification |
| **C** | [Consistent](consistent.md) | Uniform patterns across all endpoints |
| **T** | [Testable](testable.md) | Safe, low-cost experimentation available |

## Principle Relationships

```
┌─────────────────────────────────────────────────────────┐
│                    DETERMINISTIC                         │
│         (Foundation: Predictable Behavior)               │
└───────────────────────┬─────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
┌───────────────┐ ┌───────────────┐ ┌───────────────┐
│ INTROSPECTABLE│ │   EXPLICIT    │ │  RECOVERABLE  │
│ (Discovery)   │ │ (Constraints) │ │   (Errors)    │
└───────┬───────┘ └───────┬───────┘ └───────┬───────┘
        │                 │                 │
        └─────────────────┼─────────────────┘
                          ▼
              ┌───────────────────────┐
              │      CONSISTENT       │
              │  (Uniform Patterns)   │
              └───────────┬───────────┘
                          ▼
              ┌───────────────────────┐
              │       TESTABLE        │
              │ (Safe Experimentation)│
              └───────────────────────┘
```

## Quick Reference

### Deterministic

> APIs must behave predictably with strictly defined inputs and outputs.

**Key requirements:**

- Explicit type definitions for all fields
- Required fields clearly marked
- `additionalProperties: false` on objects
- Consistent nullability declarations

**Enforcement:** `ax-deterministic-*` rules

---

### Introspectable

> APIs must expose machine-readable capabilities and schemas.

**Key requirements:**

- Complete OpenAPI/AsyncAPI specifications
- `operationId` on every operation
- `x-ax-capabilities` for intent discovery
- Schema definitions for all types

**Enforcement:** `ax-introspectable-*` rules

---

### Recoverable

> Errors must be structured and enable automated correction.

**Key requirements:**

- Machine-readable error codes
- Actionable fix suggestions
- Retry semantics (`x-ax-retryable`)
- Field-level error details

**Enforcement:** `ax-recoverable-*` rules

---

### Explicit

> All constraints and requirements must be declared in the specification.

**Key requirements:**

- `required` arrays in schemas
- Validation constraints (`minimum`, `maximum`, `pattern`)
- `enum` for constrained values
- `default` values declared

**Enforcement:** `ax-explicit-*` rules

---

### Consistent

> APIs must follow uniform patterns across endpoints.

**Key requirements:**

- Consistent naming conventions
- Uniform pagination patterns
- Standard error response format
- Predictable URL structures

**Enforcement:** `ax-consistent-*` rules

---

### Testable

> APIs must support safe, low-cost experimentation.

**Key requirements:**

- Sandbox environments
- Test/dry-run modes
- Example values in schemas
- `x-ax-sandboxable` markers

**Enforcement:** `ax-testable-*` rules

## Applying Principles Together

When designing an API, consider each principle:

1. **Start with Deterministic** - Define strict schemas
2. **Add Introspectable** - Ensure machine-readable metadata
3. **Make it Recoverable** - Structure error responses
4. **Be Explicit** - Declare all constraints
5. **Ensure Consistent** - Apply patterns uniformly
6. **Enable Testable** - Provide sandbox environment

## See Also

- [Compliance Levels](../compliance/levels.md) - Progressive adoption framework
- [AX Spec](https://github.com/plexusone/ax-spec) - Enforcement tooling
