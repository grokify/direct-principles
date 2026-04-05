# DIRECT Principles

Design principles for Agent Experience (AX) - building software interfaces that autonomous AI agents can reliably consume.

DIRECT is to Agent Experience what SOLID is to Object-Oriented Design: a foundational set of principles that guide the creation of agent-friendly APIs, CLIs, SDKs, and documentation.

## The Six Principles

| Principle | Why Agents Need It |
|-----------|-------------------|
| **D**eterministic | Agents trust the system to behave the same way each time, making safe recovery from errors natural |
| **I**ntrospectable | Agents explore capabilities and understand data structures without requiring external docs or humans |
| **R**ecoverable | Agents can diagnose what went wrong and take corrective action without human intervention |
| **E**xplicit | Agents operate within clear boundaries and constraints so they act with confidence |
| **C**onsistent | Agents build mental models once and apply them everywhere, scaling their effectiveness |
| **T**estable | Agents can try actions safely before committing, learning what works without causing harm |

## Why DIRECT?

Traditional developer experience (DX) optimizes for:
> "How fast can a human ship?"

Agent Experience (AX) optimizes for:
> "How reliably can an agent figure it out?"

These are not the same problem.

Humans can:
- Read prose documentation and infer meaning
- Handle ambiguous error messages
- Debug issues through trial and error
- Tolerate inconsistencies across endpoints

Agents cannot do any of these reliably. They need:
- Machine-readable specifications
- Structured, actionable errors
- Deterministic behavior
- Consistent patterns to generalize from

DIRECT codifies what agents need to succeed.

## Principle Details

### D - Deterministic

APIs must behave predictably with strictly defined inputs and outputs.

**What this means:**
- Same input always produces same output shape
- No "sometimes this field is null" behavior
- Explicit type definitions for all fields
- Required fields clearly marked

**Anti-patterns:**
- `additionalProperties: true` allowing arbitrary fields
- Optional fields that are actually required
- Dynamic response shapes based on context
- Undocumented field behaviors

**Enforcement:** [ax-deterministic-* rules](https://github.com/grokify/ax-spec)

### I - Introspectable

APIs must expose machine-readable capabilities and schemas.

**What this means:**
- Complete OpenAPI/AsyncAPI specifications
- Operation IDs for programmatic reference
- Capability tags for intent discovery
- Schema definitions for all types

**Anti-patterns:**
- Documentation only in prose format
- Missing operationId on endpoints
- Undocumented response types
- Hidden capabilities requiring human knowledge

**Enforcement:** [ax-introspectable-* rules](https://github.com/grokify/ax-spec)

### R - Recoverable

Errors must be structured and enable automated correction.

**What this means:**
- Machine-readable error codes
- Actionable fix suggestions
- Retry semantics (retryable, idempotent)
- Structured error response schemas

**Anti-patterns:**
- `400 Bad Request` with no details
- Human-readable error messages only
- Missing retry guidance
- Unstructured error bodies

**Example:**
```json
{
  "error_code": "INVALID_DATE_RANGE",
  "message": "start_date must be before end_date",
  "retryable": false,
  "suggestion": "Ensure start_date < end_date"
}
```

**Enforcement:** [ax-recoverable-* rules](https://github.com/grokify/ax-spec)

### E - Explicit

All constraints and requirements must be declared in the specification.

**What this means:**
- Required fields marked in schema
- Parameter constraints documented
- Format requirements explicit (not implied)
- No hidden validation rules

**Anti-patterns:**
- "See documentation for requirements"
- Implicit defaults not in spec
- Validation rules only in server code
- Undocumented field formats

**Enforcement:** [ax-explicit-* rules](https://github.com/grokify/ax-spec)

### C - Consistent

APIs must follow uniform patterns across endpoints.

**What this means:**
- Consistent naming conventions
- Uniform pagination patterns
- Standard error response shapes
- Predictable URL structures

**Anti-patterns:**
- Mixed naming styles (camelCase + snake_case)
- Different pagination per endpoint
- Inconsistent error formats
- Arbitrary URL patterns

**Enforcement:** [ax-consistent-* rules](https://github.com/grokify/ax-spec)

### T - Testable

APIs must support safe, low-cost experimentation.

**What this means:**
- Sandbox environments available
- Test/dry-run modes for mutations
- Example values in schemas
- Mock data for development

**Anti-patterns:**
- Production-only APIs
- No test accounts available
- Missing example values
- Expensive iteration costs

**Enforcement:** [ax-testable-* rules](https://github.com/grokify/ax-spec)

## Applying DIRECT

### To APIs

Use [AX Spec](https://github.com/grokify/ax-spec) Spectral rules to lint OpenAPI specifications:

```bash
vacuum lint --ruleset ax-spec/rules/ax-openapi.json your-api.yaml
```

### To CLIs

Design CLIs following these patterns:

| DIRECT | CLI Pattern |
|--------|-------------|
| Deterministic | Same flags always produce same output format |
| Introspectable | `--help` with detailed examples, `--list-commands` |
| Recoverable | Semantic exit codes, `--format json` for errors |
| Explicit | All options via flags, no interactive prompts |
| Consistent | Uniform flag naming (`--format`, `--output`) |
| Testable | `--dry-run` mode, stdin/stdout piping |

### To SDKs

Use layered SDK architecture:

1. **Foundation Layer** - Generated from spec (e.g., ogen)
   - Machine-accurate, 1:1 mapping to API
   - No abstraction, no magic
   - Agents use this layer directly

2. **Convenience Layer** - Human-friendly wrappers
   - Simplified method signatures
   - Default values and helpers
   - Humans use this layer

### To Documentation

Structure documentation for machine consumption:

- Endpoint summaries in structured format
- Parameter tables with types and constraints
- Examples in JSON (not just prose)
- Capability indexing for discovery

## Compliance Levels

Progressive adoption through defined levels:

| Level | Name | Requirements |
|-------|------|--------------|
| **AX-L1** | Structured | Valid spec, explicit types, operation IDs |
| **AX-L2** | Deterministic | Strict schemas, explicit required fields |
| **AX-L3** | Agent-Ready | Full DIRECT compliance with AX extensions |

## Token Efficiency

Agents pay for context. DIRECT-compliant interfaces should optimize for token efficiency:

| Format | Relative Tokens | Use Case |
|--------|-----------------|----------|
| Raw text | 1.0x | Human reading |
| JSON | 0.6x | Machine parsing |
| JSON-compact | 0.5x | Bandwidth-constrained |
| TOON | 0.4x | LLM consumption |

See [structured-changelog](https://github.com/grokify/structured-changelog) for TOON (Token-Oriented Object Notation) implementation.

## Related Projects

### Implementation

- [AX Spec](https://github.com/grokify/ax-spec) - Spectral rules for OpenAPI
- [schemalint](https://github.com/grokify/schemalint) - JSON Schema linter for Go
- [structured-changelog](https://github.com/grokify/structured-changelog) - TOON-optimized CLI

### Background

- [Agent Experience Article](https://github.com/grokify/grokify-articles/tree/master/agent-experience-ax)
- [PlexusOne](https://github.com/plexusone) - SDK integration case studies

## Comparison to SOLID

| SOLID (OOP) | DIRECT (AX) |
|-------------|-------------|
| Single Responsibility | Deterministic |
| Open/Closed | Introspectable |
| Liskov Substitution | Recoverable |
| Interface Segregation | Explicit |
| Dependency Inversion | Consistent + Testable |

Both provide foundational principles for their domains. SOLID guides class design; DIRECT guides interface design for agent consumption.

## License

MIT
