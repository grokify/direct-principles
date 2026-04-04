# Introspectable

> APIs must expose machine-readable capabilities and schemas.

## Definition

An interface is **introspectable** when agents can programmatically discover what it does, what inputs it accepts, and what outputs it produces—without reading prose documentation.

## Why It Matters

Agents don't read documentation like humans do. They need:
- Structured metadata to understand capabilities
- Schema definitions to generate valid requests
- Operation identifiers to reference endpoints programmatically

An API with great human docs but poor machine-readable specs fails agents.

## Requirements

### R1: Complete OpenAPI/AsyncAPI Specification

Every endpoint must be fully described in the spec, matching production behavior.

```yaml
# Good - complete spec
openapi: 3.1.0
paths:
  /users:
    get:
      operationId: listUsers
      summary: List all users
      parameters:
        - name: limit
          in: query
          schema:
            type: integer

# Bad - endpoint exists but not in spec
# /users/export exists in production but not documented
```

### R2: Operation IDs

Every operation must have a unique `operationId` for programmatic reference.

```yaml
# Good
paths:
  /payments:
    post:
      operationId: createPayment

# Bad - no operationId
paths:
  /payments:
    post:
      summary: Create payment  # How do agents reference this?
```

### R3: Summaries and Descriptions

Operations must have `summary` for brief identification and `description` for details.

```yaml
# Good
paths:
  /payments:
    post:
      operationId: createPayment
      summary: Create a new payment
      description: |
        Initiates a payment transaction between accounts.
        Requires amount in smallest currency unit (e.g., cents for USD).
```

### R4: Capability Tags

Operations should declare semantic capabilities for intent discovery.

```yaml
# Good - agent can search for "refund" capabilities
paths:
  /payments/{id}/refund:
    post:
      x-ax-capabilities:
        - refund_payment
        - reverse_transaction

# Bad - no capability metadata
paths:
  /payments/{id}/refund:
    post:
      # Agent must parse URL to guess intent
```

### R5: Schema Definitions

All request and response bodies must have schema definitions.

```yaml
# Good
responses:
  '200':
    content:
      application/json:
        schema:
          $ref: '#/components/schemas/Payment'

components:
  schemas:
    Payment:
      type: object
      properties:
        id:
          type: string
        amount:
          type: integer

# Bad - no schema
responses:
  '200':
    description: Returns payment object
    # No schema - agent can't know structure
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Missing operationId | Can't reference programmatically | Add unique IDs |
| Docs-only endpoints | Spec doesn't match production | Keep spec in sync |
| Free-form responses | Agent can't parse reliably | Define schemas |
| Capability in prose only | Agent can't discover intent | Add x-ax-capabilities |
| Inline schemas everywhere | Hard to reference and reuse | Use $ref components |

## Enforcement

AX Spec rules:

- `ax-introspectable-capabilities` - Operations should declare capabilities
- `ax-introspectable-operation-id` - Operations must have operationId
- `ax-introspectable-summary` - Operations must have summary

## Example: Capability Discovery

An agent searching for "payment refund" capabilities:

```python
# With x-ax-capabilities
def find_refund_operations(spec):
    for path, methods in spec['paths'].items():
        for method, operation in methods.items():
            capabilities = operation.get('x-ax-capabilities', [])
            if 'refund_payment' in capabilities:
                yield operation['operationId']

# Without - must parse URLs and guess
def find_refund_operations_legacy(spec):
    for path, methods in spec['paths'].items():
        if 'refund' in path:  # Fragile heuristic
            for method, operation in methods.items():
                yield operation.get('operationId', path)
```

## Relationship to Other Principles

- **Deterministic** - Introspectable schemas must be deterministic
- **Explicit** - Introspection reveals explicit constraints
- **Consistent** - Introspectable patterns should be uniform
