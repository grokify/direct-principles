# Recoverable

> Errors must be structured and enable automated correction.

## Definition

An interface is **recoverable** when agents can parse errors, understand what went wrong, and take corrective action without human intervention.

## Why It Matters

Agents iterate. They:
1. Generate a request
2. Send it
3. Fail
4. Learn from the error
5. Fix and retry

If errors are opaque (`400 Bad Request`), agents stall. Structured errors enable the feedback loop that makes agents effective.

## Requirements

### R1: Machine-Readable Error Codes

Every error must have a consistent, parseable code.

```json
// Good
{
  "error_code": "INVALID_DATE_RANGE",
  "message": "start_date must be before end_date"
}

// Bad
{
  "error": "Bad Request"
}
```

### R2: Actionable Suggestions

Errors should include how to fix them.

```json
// Good
{
  "error_code": "AMOUNT_TOO_LARGE",
  "message": "Amount exceeds maximum",
  "suggestion": "Maximum amount is 10000. Reduce amount or split into multiple payments."
}

// Bad
{
  "error_code": "AMOUNT_TOO_LARGE",
  "message": "Amount exceeds maximum"
  // How much is the maximum? What should I do?
}
```

### R3: Retry Semantics

Operations should indicate whether they're safe to retry.

```yaml
# Good
paths:
  /payments:
    post:
      x-ax-retryable: false  # Don't retry - may create duplicates

  /payments/{id}:
    get:
      x-ax-retryable: true   # Safe to retry
```

### R4: Idempotency Indication

Operations that are idempotent should say so.

```yaml
# Good
paths:
  /payments/{id}/refund:
    post:
      x-ax-idempotent: true  # Same refund request = same result
```

### R5: Structured Error Schemas

Error responses must have defined schemas, not free-form text.

```yaml
# Good
responses:
  '400':
    content:
      application/json:
        schema:
          $ref: '#/components/schemas/Error'

components:
  schemas:
    Error:
      type: object
      required:
        - error_code
        - message
      properties:
        error_code:
          type: string
        message:
          type: string
        suggestion:
          type: string
        retryable:
          type: boolean
        details:
          type: array
          items:
            $ref: '#/components/schemas/FieldError'
```

### R6: Field-Level Error Details

Validation errors should identify which fields failed.

```json
{
  "error_code": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "details": [
    {
      "field": "amount",
      "code": "INVALID_VALUE",
      "message": "must be greater than 0"
    },
    {
      "field": "currency",
      "code": "INVALID_ENUM",
      "message": "must be one of: USD, EUR, GBP"
    }
  ]
}
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| `400 Bad Request` only | Agent can't diagnose | Add error_code |
| Human-only messages | Agent can't parse | Structured codes |
| No retry guidance | Agent may retry unsafely | Add x-ax-retryable |
| Validation errors without fields | Agent can't fix specific field | Add field details |
| HTML error pages | Agent can't parse | Always return JSON |

## Error Code Conventions

Use consistent, descriptive error codes:

```
RESOURCE_NOT_FOUND      - 404 scenarios
VALIDATION_ERROR        - 400 with field issues
INVALID_{FIELD}         - Specific field invalid
INSUFFICIENT_{RESOURCE} - Business rule violation
RATE_LIMIT_EXCEEDED     - Too many requests
UNAUTHORIZED            - Auth required
FORBIDDEN               - Auth succeeded but not allowed
CONFLICT                - State conflict (409)
```

## Enforcement

AX Spec rules:

- `ax-recoverable-error-structure` - Error responses should include error code
- `ax-recoverable-error-schema` - Error responses must have defined schema
- `ax-recoverable-retryable` - Mutating operations should indicate retry safety
- `ax-recoverable-idempotent` - PUT/DELETE should indicate idempotency

## Example: Self-Healing Flow

```
Agent: POST /payments { amount: -100, currency: "INVALID" }

API: {
  "error_code": "VALIDATION_ERROR",
  "details": [
    { "field": "amount", "code": "MUST_BE_POSITIVE", "message": "must be > 0" },
    { "field": "currency", "code": "INVALID_ENUM", "message": "must be USD, EUR, or GBP" }
  ],
  "suggestion": "Fix the indicated fields and retry"
}

Agent: [Fixes amount to 100, currency to USD]
Agent: POST /payments { amount: 100, currency: "USD" }

API: 201 Created
```

## Relationship to Other Principles

- **Explicit** - Recoverable errors explain explicit constraints
- **Deterministic** - Error responses should have consistent structure
- **Testable** - Recoverable APIs are easier to test error paths
