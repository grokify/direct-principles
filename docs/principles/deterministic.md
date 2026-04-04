# Deterministic

> APIs must behave predictably with strictly defined inputs and outputs.

## Definition

An interface is **deterministic** when the same input always produces the same output shape, with no ambiguity in field presence, types, or behavior.

## Why It Matters

Agents cannot handle ambiguity. When an API returns:
- "sometimes this field is null"
- "this field may or may not be present"
- "the response shape depends on context"

...agents fail. They generate code expecting one structure and receive another.

Humans handle this through documentation reading and debugging. Agents need explicit contracts.

## Requirements

### R1: Explicit Type Definitions

Every field must have an explicit type in the schema.

```yaml
# Good
properties:
  amount:
    type: integer
    minimum: 1

# Bad - no type specified
properties:
  amount: {}
```

### R2: Required Fields Declared

Required fields must be explicitly marked, not implied.

```yaml
# Good
required:
  - amount
  - currency
properties:
  amount:
    type: integer
  currency:
    type: string

# Bad - "required" not declared
properties:
  amount:
    type: integer
```

### R3: No Additional Properties

Object schemas should reject unknown fields.

```yaml
# Good
type: object
additionalProperties: false
properties:
  id:
    type: string

# Bad - allows arbitrary fields
type: object
additionalProperties: true
```

### R4: Consistent Nullability

Nullable fields must be explicitly marked.

```yaml
# Good - explicit nullable
properties:
  middle_name:
    type: string
    nullable: true

# Bad - ambiguous
properties:
  middle_name:
    type: string
    # Is this nullable? Who knows.
```

### R5: Stable Response Shapes

The same endpoint must return the same structure regardless of data.

```yaml
# Good - consistent shape
{
  "data": [],
  "pagination": { "total": 0 }
}

# Bad - shape changes when empty
{
  "message": "No results found"
}
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| `additionalProperties: true` | Arbitrary fields break type safety | Set to `false` |
| Optional but actually required | Agent sends incomplete requests | Mark as `required` |
| Dynamic response shapes | Code generation fails | Consistent structure |
| Implicit defaults | Agent doesn't know what to expect | Document defaults |
| Format without type | `format: date` but no `type: string` | Add explicit type |

## Enforcement

AX Spec rules:

- `ax-deterministic-required-fields` - Operations must declare required fields
- `ax-deterministic-schema-type` - Properties must have explicit types
- `ax-deterministic-no-additional-properties` - Objects should reject unknown fields

## Example

### Before (Non-Deterministic)

```yaml
paths:
  /users/{id}:
    get:
      responses:
        '200':
          content:
            application/json:
              schema:
                type: object
                properties:
                  name:
                    type: string
                  email: {}  # No type
                  # required not specified
```

### After (Deterministic)

```yaml
paths:
  /users/{id}:
    get:
      x-ax-required-fields:
        - id
      responses:
        '200':
          content:
            application/json:
              schema:
                type: object
                additionalProperties: false
                required:
                  - id
                  - name
                  - email
                properties:
                  id:
                    type: string
                    format: uuid
                  name:
                    type: string
                  email:
                    type: string
                    format: email
                  phone:
                    type: string
                    nullable: true
```

## Relationship to Other Principles

- **Explicit** - Deterministic requires explicit declarations
- **Consistent** - Deterministic patterns should be consistent across endpoints
- **Testable** - Deterministic APIs are easier to test with predictable outputs
