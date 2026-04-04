# DIRECT Principles

Design principles for Agent Experience (AX) - building software interfaces that autonomous AI agents can reliably consume.

**DIRECT is to Agent Experience what SOLID is to Object-Oriented Design:** a foundational set of principles that guide the creation of agent-friendly APIs, CLIs, SDKs, and documentation.

## The Six Principles

| Principle | Summary |
|-----------|---------|
| [**D**eterministic](principles/deterministic.md) | Predictable behavior with strictly defined inputs and outputs |
| [**I**ntrospectable](principles/introspectable.md) | Machine-readable capabilities, schemas, and metadata |
| [**R**ecoverable](principles/recoverable.md) | Structured errors that enable automated correction |
| [**E**xplicit](principles/explicit.md) | All constraints and requirements declared in specification |
| [**C**onsistent](principles/consistent.md) | Uniform patterns across endpoints and interfaces |
| [**T**estable](principles/testable.md) | Safe, low-cost experimentation in sandbox environments |

## Why DIRECT?

Traditional developer experience (DX) optimizes for:

> "How fast can a human ship?"

Agent Experience (AX) optimizes for:

> "How reliably can an agent figure it out?"

**These are not the same problem.**

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

## Compliance Levels

Progressive adoption through defined levels:

| Level | Name | Requirements |
|-------|------|--------------|
| **AX-L1** | Structured | Valid spec, explicit types, operation IDs |
| **AX-L2** | Deterministic | Strict schemas, explicit required fields |
| **AX-L3** | Agent-Ready | Full DIRECT compliance with AX extensions |

See [Compliance Levels](compliance/levels.md) for detailed requirements.

## Applying DIRECT

### To APIs

Use [AX Spec](https://github.com/plexusone/ax-spec) Spectral rules to lint OpenAPI specifications:

```bash
vacuum lint --ruleset ax-spec/rules/ax-openapi.json your-api.yaml
```

### To CLIs

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

- [AX Spec](https://github.com/plexusone/ax-spec) - Spectral rules for OpenAPI
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
