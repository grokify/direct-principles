# Explicit

> Agents operate within clear boundaries and constraints so they act with confidence.

## Definition

An interface is **explicit** when every constraint, format, validation rule, and requirement is declared in the specification—not hidden in server code, documentation prose, or tribal knowledge.

## Why Agents Need It

- Unambiguous parameters and behavior
- Clear input validation and constraints
- Reduces agent hesitation and errors

Agents can only work with what's in the spec. If a field:

- Has a maximum length documented in prose but not schema
- Requires a specific format "everyone knows"
- Has validation rules only in server code

...agents will fail because they can't access that information programmatically.

## Requirements

### R1: Required Fields in Schema

Use `required` array, not prose documentation.

```yaml
# Good
type: object
required:
  - email
  - password
properties:
  email:
    type: string
  password:
    type: string

# Bad - "required" in description only
type: object
properties:
  email:
    type: string
    description: "Required. User's email address."
```

### R2: Constraints in Schema

Validation rules must be in the schema.

```yaml
# Good
properties:
  age:
    type: integer
    minimum: 0
    maximum: 150
  email:
    type: string
    format: email
    maxLength: 255
  username:
    type: string
    pattern: "^[a-zA-Z0-9_]{3,20}$"

# Bad - constraints in description
properties:
  age:
    type: integer
    description: "Must be between 0 and 150"
  username:
    type: string
    description: "3-20 alphanumeric characters or underscore"
```

### R3: Enum Values Declared

Constrained string values must use `enum`.

```yaml
# Good
properties:
  status:
    type: string
    enum:
      - pending
      - completed
      - failed
      - refunded

# Bad - valid values in description
properties:
  status:
    type: string
    description: "One of: pending, completed, failed, refunded"
```

### R4: Defaults Declared

Default values must be in the schema.

```yaml
# Good
properties:
  limit:
    type: integer
    default: 20
    minimum: 1
    maximum: 100

# Bad - default only in docs
properties:
  limit:
    type: integer
    description: "Defaults to 20 if not specified"
```

### R5: Format Requirements Explicit

Use standard `format` keywords.

```yaml
# Good
properties:
  created_at:
    type: string
    format: date-time
  user_id:
    type: string
    format: uuid
  website:
    type: string
    format: uri

# Bad - format in description
properties:
  created_at:
    type: string
    description: "ISO 8601 datetime"
```

### R6: Request Body Required Flag

Explicitly set `required` on request bodies.

```yaml
# Good
requestBody:
  required: true
  content:
    application/json:
      schema:
        $ref: '#/components/schemas/CreateUser'

# Bad - required not specified
requestBody:
  content:
    application/json:
      schema:
        $ref: '#/components/schemas/CreateUser'
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| "See docs for format" | Agent can't access external docs | Put in schema |
| Description-only constraints | Can't be validated automatically | Use schema keywords |
| Server-side validation only | Agent discovers at runtime | Declare in spec |
| Implicit defaults | Agent sends wrong values | Use `default` keyword |
| Magic values | Agent can't discover them | Use `enum` |

## Schema Constraint Keywords

| Constraint | Keyword | Example |
|------------|---------|---------|
| Minimum value | `minimum` | `minimum: 0` |
| Maximum value | `maximum` | `maximum: 100` |
| Exclusive bounds | `exclusiveMinimum/Maximum` | `exclusiveMinimum: 0` |
| String length | `minLength/maxLength` | `maxLength: 255` |
| Array length | `minItems/maxItems` | `maxItems: 10` |
| Pattern match | `pattern` | `pattern: "^[A-Z]{3}$"` |
| Value set | `enum` | `enum: [a, b, c]` |
| Default | `default` | `default: 20` |
| Format | `format` | `format: email` |
| Nullable | `nullable` | `nullable: true` |

## Enforcement

AX Spec rules:

- `ax-explicit-request-body-required` - Request bodies must set required
- `ax-explicit-parameter-required` - Parameters must set required
- `ax-explicit-enum-values` - Constrained strings should use enum

## Example

### Before (Implicit)

```yaml
paths:
  /users:
    post:
      summary: Create user
      description: |
        Creates a new user account.

        **Required fields:** email, password
        **Password:** Must be 8-128 characters with at least one number
        **Email:** Must be valid email format
        **Role:** One of admin, user, guest (defaults to user)
      requestBody:
        content:
          application/json:
            schema:
              type: object
              properties:
                email:
                  type: string
                password:
                  type: string
                role:
                  type: string
```

### After (Explicit)

```yaml
paths:
  /users:
    post:
      operationId: createUser
      summary: Create user
      x-ax-required-fields:
        - email
        - password
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              additionalProperties: false
              required:
                - email
                - password
              properties:
                email:
                  type: string
                  format: email
                  maxLength: 255
                  example: "user@example.com"
                password:
                  type: string
                  minLength: 8
                  maxLength: 128
                  pattern: ".*[0-9].*"
                  example: "SecurePass1"
                role:
                  type: string
                  enum:
                    - admin
                    - user
                    - guest
                  default: user
```

## Relationship to Other Principles

- **Deterministic** - Explicit constraints enable deterministic behavior
- **Introspectable** - Explicit specs are fully introspectable
- **Recoverable** - Explicit constraints appear in validation errors
