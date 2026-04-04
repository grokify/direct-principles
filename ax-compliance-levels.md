# AX Compliance Levels

Progressive compliance levels for Agent Experience adoption.

## Overview

Not every API needs full DIRECT compliance from day one. AX defines progressive levels that allow incremental adoption while providing clear targets.

## Level Summary

| Level | Name | Target | Key Requirements |
|-------|------|--------|------------------|
| **AX-L1** | Structured | Basic machine consumption | Valid spec, explicit types, operation IDs |
| **AX-L2** | Deterministic | Reliable code generation | Strict schemas, required fields, no ambiguity |
| **AX-L3** | Agent-Ready | Full autonomous operation | DIRECT extensions, structured errors, capability discovery |

## AX-L1: Structured

**Goal:** Basic machine-readable API that tools can parse.

### Requirements

| DIRECT | Requirement |
|--------|-------------|
| **D** | All schema properties have explicit `type` |
| **I** | All operations have `operationId` and `summary` |
| **R** | - |
| **E** | Parameters declare `required` explicitly |
| **C** | - |
| **T** | - |

### Enforcement

```bash
vacuum lint --ruleset ax-spec/rules/profiles/ax-l1-structured.yaml api.yaml
```

### Example Checklist

- [ ] Valid OpenAPI 3.0+ specification
- [ ] Every property has `type` defined
- [ ] Every operation has unique `operationId`
- [ ] Every operation has `summary`
- [ ] Query/path parameters set `required: true/false`

## AX-L2: Deterministic

**Goal:** Predictable behavior suitable for code generation.

### Requirements

| DIRECT | Requirement |
|--------|-------------|
| **D** | `additionalProperties: false` on objects |
| **D** | `x-ax-required-fields` on operations |
| **I** | All L1 requirements |
| **R** | Error responses have defined schemas |
| **E** | Request bodies set `required` explicitly |
| **E** | Schema `required` arrays match actual requirements |
| **C** | Consistent naming conventions |
| **T** | - |

### Enforcement

```bash
vacuum lint --ruleset ax-spec/rules/profiles/ax-l2-deterministic.yaml api.yaml
```

### Example Checklist

- [ ] All L1 requirements
- [ ] Object schemas set `additionalProperties: false`
- [ ] Operations declare `x-ax-required-fields`
- [ ] Request bodies have `required: true/false`
- [ ] Schema `required` arrays are accurate
- [ ] 4xx/5xx responses have schema definitions
- [ ] Consistent field naming (all snake_case or all camelCase)

## AX-L3: Agent-Ready

**Goal:** Full autonomous agent compatibility.

### Requirements

| DIRECT | Requirement |
|--------|-------------|
| **D** | All L2 requirements |
| **I** | `x-ax-capabilities` on operations |
| **R** | `x-ax-error-code` on error responses |
| **R** | `x-ax-retryable` on mutating operations |
| **R** | `x-ax-idempotent` on PUT/DELETE |
| **E** | All L2 requirements |
| **C** | Consistent pagination patterns |
| **C** | Consistent error response format |
| **T** | `x-ax-sandboxable` on operations |
| **T** | Example values on schema properties |

### Enforcement

```bash
vacuum lint --ruleset ax-spec/rules/profiles/ax-l3-agent-ready.yaml api.yaml
```

### Example Checklist

- [ ] All L2 requirements
- [ ] Operations have `x-ax-capabilities` tags
- [ ] Error responses include `x-ax-error-code`
- [ ] POST/PUT/PATCH/DELETE have `x-ax-retryable`
- [ ] PUT/DELETE have `x-ax-idempotent`
- [ ] Mutating operations have `x-ax-sandboxable`
- [ ] Schema properties have `example` values
- [ ] Pagination is consistent across list endpoints
- [ ] Error response format is uniform

## Migration Path

### From L0 (No Compliance) to L1

1. Generate OpenAPI spec from code annotations or write manually
2. Add `type` to all schema properties
3. Add `operationId` and `summary` to all operations
4. Add `required` to all parameters

**Effort:** Low - mostly documentation

### From L1 to L2

1. Add `additionalProperties: false` to object schemas
2. Add `x-ax-required-fields` to operations
3. Define error response schemas
4. Audit and fix `required` arrays
5. Standardize naming conventions

**Effort:** Medium - may require spec refactoring

### From L2 to L3

1. Add `x-ax-capabilities` to operations
2. Add `x-ax-error-code` to error responses
3. Add retry/idempotency flags
4. Add sandbox indicators
5. Add example values throughout

**Effort:** Medium - requires understanding agent use cases

## Compliance Badge

Display your compliance level:

```markdown
![AX-L1](https://img.shields.io/badge/AX-L1%20Structured-blue)
![AX-L2](https://img.shields.io/badge/AX-L2%20Deterministic-green)
![AX-L3](https://img.shields.io/badge/AX-L3%20Agent--Ready-purple)
```

## Future Levels

### AX-L4: Autonomous (Proposed)

- Sandbox environment available
- Observability metadata (correlation IDs)
- Replay/debugging endpoints
- Self-healing error suggestions (`x-ax-error-suggestion`)

### AX-L5: Self-Optimizing (Proposed)

- Cost/token estimation (`x-ax-cost-estimate`)
- Rate limit awareness
- Agent feedback integration
- Automatic capability evolution

## Validation Tools

| Tool | Purpose |
|------|---------|
| [Vacuum](https://github.com/daveshanley/vacuum) | Run AX Spectral rules |
| [Spectral](https://github.com/stoplightio/spectral) | Alternative linter |
| [schemalint](https://github.com/grokify/schemalint) | JSON Schema validation |
| [ogen](https://github.com/ogen-go/ogen) | Go code generation (validates spec) |

## Related

- [AX Spec](https://github.com/grokify/ax-spec) - Spectral rulesets for each level
- [DIRECT Principles](./README.md) - The underlying principles
