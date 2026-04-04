---
marp: true
theme: default
paginate: true
backgroundColor: #fff
style: |
  section {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
  }
  h1 {
    color: #1a237e;
  }
  h2 {
    color: #303f9f;
  }
  table {
    font-size: 0.85em;
  }
  code {
    background-color: #f5f5f5;
  }
---

# DIRECT Principles

## Design Principles for Agent Experience (AX)

Building software interfaces that autonomous AI agents can reliably consume.

---

# The Problem

**Traditional DX optimizes for humans:**
> "How fast can a human ship?"

**Agent Experience (AX) needs:**
> "How reliably can an agent figure it out?"

These are not the same problem.

---

# What Agents Can't Do

Humans can:
- Read prose documentation and infer meaning
- Handle ambiguous error messages
- Debug through trial and error
- Tolerate inconsistencies

**Agents cannot do any of these reliably.**

---

# What Agents Need

- Machine-readable specifications
- Structured, actionable errors
- Deterministic behavior
- Consistent patterns to generalize from

**DIRECT codifies these requirements.**

---

# D.I.R.E.C.T.

| Principle | Summary |
|-----------|---------|
| **D**eterministic | Predictable behavior, strictly defined I/O |
| **I**ntrospectable | Machine-readable capabilities & schemas |
| **R**ecoverable | Structured errors enable auto-correction |
| **E**xplicit | All constraints in specification |
| **C**onsistent | Uniform patterns across endpoints |
| **T**estable | Safe, low-cost experimentation |

---

# D - Deterministic

> Same input always produces same output shape.

**Requirements:**
- Explicit type definitions
- Required fields declared
- `additionalProperties: false`
- Consistent nullability

---

# Deterministic: Anti-Patterns

```yaml
# Bad - no type, no required
properties:
  amount: {}
  email:
    type: string
    # Is this required? Who knows.
```

```yaml
# Good - explicit everything
required: [amount, email]
properties:
  amount:
    type: integer
    minimum: 1
  email:
    type: string
    format: email
```

---

# I - Introspectable

> Machine-readable capabilities and schemas.

**Requirements:**
- Complete OpenAPI specs
- `operationId` on every operation
- `x-ax-capabilities` tags
- Schema definitions for all types

---

# Introspectable: Capability Discovery

```yaml
# With x-ax-capabilities - agent can search
paths:
  /payments/{id}/refund:
    post:
      x-ax-capabilities:
        - refund_payment
        - reverse_transaction

# Without - agent must parse URL and guess
paths:
  /payments/{id}/refund:
    post:
      # Hope "refund" is in the URL...
```

---

# R - Recoverable

> Structured errors enable automated correction.

**Requirements:**
- Machine-readable error codes
- Actionable fix suggestions
- Retry semantics
- Field-level error details

---

# Recoverable: Error Structure

```json
// Bad
{ "error": "Bad Request" }

// Good
{
  "error_code": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "details": [
    { "field": "amount", "code": "MUST_BE_POSITIVE" },
    { "field": "currency", "code": "INVALID_ENUM" }
  ],
  "suggestion": "Fix indicated fields and retry"
}
```

---

# E - Explicit

> All constraints declared in specification.

**Requirements:**
- `required` arrays in schemas
- Validation keywords (`minimum`, `pattern`)
- `enum` for constrained values
- `default` values declared

---

# Explicit: Schema Constraints

| Constraint | Keyword | Example |
|------------|---------|---------|
| Min/max value | `minimum/maximum` | `minimum: 0` |
| String length | `minLength/maxLength` | `maxLength: 255` |
| Pattern | `pattern` | `"^[A-Z]{3}$"` |
| Value set | `enum` | `[USD, EUR, GBP]` |
| Default | `default` | `default: 20` |
| Format | `format` | `format: email` |

---

# C - Consistent

> Uniform patterns across endpoints.

**Requirements:**
- Consistent naming conventions
- Uniform pagination patterns
- Standard error format
- Predictable URL structures

---

# Consistent: Pagination

```yaml
# Bad - mixed patterns
GET /users?limit=20&offset=0
GET /orders?page=1&per_page=20
GET /products?cursor=abc123

# Good - same everywhere
GET /users?limit=20&offset=0
GET /orders?limit=20&offset=0
GET /products?limit=20&offset=0
```

---

# T - Testable

> Safe, low-cost experimentation available.

**Requirements:**
- Sandbox environments
- Test/dry-run modes
- Example values in schemas
- `x-ax-sandboxable` markers

---

# Testable: Iteration Loop

```
Agent workflow:
generate → call → fail → learn → fix → retry
```

This cycle executes **hundreds of times**.

If each iteration costs money or affects production...
agents become impractical.

**Testability enables rapid iteration.**

---

# Compliance Levels

| Level | Name | Target |
|-------|------|--------|
| **AX-L1** | Structured | Basic machine consumption |
| **AX-L2** | Deterministic | Reliable code generation |
| **AX-L3** | Agent-Ready | Full autonomous operation |

Progressive adoption - start at L1, grow to L3.

---

# L1: Structured

**Goal:** Basic machine-readable API

- Valid OpenAPI 3.0+ spec
- All properties have `type`
- All operations have `operationId`
- Parameters declare `required`

**Effort:** Low - mostly documentation

---

# L2: Deterministic

**Goal:** Predictable for code generation

- All L1 requirements
- `additionalProperties: false`
- `x-ax-required-fields` on operations
- Error response schemas defined
- Consistent naming conventions

**Effort:** Medium - spec refactoring

---

# L3: Agent-Ready

**Goal:** Full autonomous operation

- All L2 requirements
- `x-ax-capabilities` on operations
- `x-ax-error-code` on errors
- `x-ax-retryable` / `x-ax-idempotent`
- Example values throughout
- `x-ax-sandboxable` markers

**Effort:** Medium - understanding agent needs

---

# Enforcement: AX Spec

Lint OpenAPI specs against DIRECT principles:

```bash
# Install
npm install -g @stoplight/spectral

# Lint
vacuum lint \
  --ruleset ax-spec/rules/ax-l3-agent-ready.yaml \
  your-api.yaml
```

40+ rules across all six principles.

---

# SOLID vs DIRECT

| SOLID (OOP) | DIRECT (AX) |
|-------------|-------------|
| Single Responsibility | Deterministic |
| Open/Closed | Introspectable |
| Liskov Substitution | Recoverable |
| Interface Segregation | Explicit |
| Dependency Inversion | Consistent + Testable |

Both: foundational principles for their domains.

---

# Getting Started

1. **Assess** - Lint current API with AX Spec
2. **Plan** - Target L1, then L2, then L3
3. **Implement** - Fix violations incrementally
4. **Validate** - Run linter in CI/CD
5. **Document** - Badge your compliance level

---

# Resources

- **DIRECT Principles:** [github.com/grokify/direct-principles](https://github.com/grokify/direct-principles)
- **AX Spec:** [github.com/plexusone/ax-spec](https://github.com/plexusone/ax-spec)
- **Case Studies:** [github.com/plexusone](https://github.com/plexusone)

---

# Summary

**DIRECT Principles:**

- **D**eterministic - Predictable behavior
- **I**ntrospectable - Machine-readable
- **R**ecoverable - Structured errors
- **E**xplicit - Constraints in spec
- **C**onsistent - Uniform patterns
- **T**estable - Safe experimentation

**Build APIs that agents can reliably consume.**

---

# Questions?

Contact:
- GitHub: [github.com/grokify](https://github.com/grokify)
- Project: [github.com/grokify/direct-principles](https://github.com/grokify/direct-principles)
