# DIRECT Principles Overview

The six DIRECT principles form a comprehensive framework for designing agent-friendly interfaces.

## The Acronym

**D.I.R.E.C.T.** stands for:

| Letter | Principle | Why Agents Need It |
|--------|-----------|-------------------|
| **D** | [Deterministic](deterministic.md) | Agents trust the system to behave the same way each time |
| **I** | [Introspectable](introspectable.md) | Agents explore capabilities without external docs or humans |
| **R** | [Recoverable](recoverable.md) | Agents diagnose and correct errors without human intervention |
| **E** | [Explicit](explicit.md) | Agents operate within clear boundaries with confidence |
| **C** | [Consistent](consistent.md) | Agents build mental models once and apply everywhere |
| **T** | [Testable](testable.md) | Agents try actions safely before committing |

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

> Agents trust the system to behave the same way each time, making safe recovery from errors natural.

**What this enables:**

- Same input → same output, every time
- Failed operations can be safely retried
- Autonomous error recovery

**Key requirements:**

- Explicit type definitions for all fields
- Required fields clearly marked
- `additionalProperties: false` on objects
- Consistent nullability declarations

**Enforcement:** `ax-deterministic-*` rules

---

### Introspectable

> Agents explore capabilities and understand data structures without requiring external docs or humans.

**What this enables:**

- Self-describing APIs and data schemas
- No need to read documentation
- Agents discover capabilities on their own

**Key requirements:**

- Complete OpenAPI/AsyncAPI specifications
- `operationId` on every operation
- `x-ax-capabilities` for intent discovery
- Schema definitions for all types

**Enforcement:** `ax-introspectable-*` rules

---

### Recoverable

> Agents can diagnose what went wrong and take corrective action without human intervention.

**What this enables:**

- Clear error messages with context
- Agents understand what failed and why
- Actionable recovery paths available

**Key requirements:**

- Machine-readable error codes
- Actionable fix suggestions
- Retry semantics (`x-ax-retryable`)
- Field-level error details

**Enforcement:** `ax-recoverable-*` rules

---

### Explicit

> Agents operate within clear boundaries and constraints so they act with confidence.

**What this enables:**

- Unambiguous parameters and behavior
- Clear input validation and constraints
- Reduces agent hesitation and errors

**Key requirements:**

- `required` arrays in schemas
- Validation constraints (`minimum`, `maximum`, `pattern`)
- `enum` for constrained values
- `default` values declared

**Enforcement:** `ax-explicit-*` rules

---

### Consistent

> Agents build mental models once and apply them everywhere, scaling their effectiveness.

**What this enables:**

- Uniform patterns across all APIs
- Agents learn rules once, apply everywhere
- Reduces cognitive load exponentially

**Key requirements:**

- Consistent naming conventions
- Uniform pagination patterns
- Standard error response format
- Predictable URL structures

**Enforcement:** `ax-consistent-*` rules

---

### Testable

> Agents can try actions safely before committing, learning what works without causing harm.

**What this enables:**

- Dry-run or sandbox modes available
- Safe experimentation without consequences
- Enables agents to learn by trying

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
