# Testable

> Agents can try actions safely before committing, learning what works without causing harm.

## Definition

An interface is **testable** when agents can experiment with it safely—without causing production side effects, incurring costs, or requiring human intervention.

## Why Agents Need It

- Dry-run or sandbox modes available
- Safe experimentation without consequences
- Enables agents to learn by trying

Agents iterate. A lot.

```
generate → call → fail → learn → fix → retry
```

This cycle may execute hundreds of times per task. If each iteration:

- Costs money
- Affects production data
- Requires manual approval

...agents become impractical.

Testability enables the rapid iteration that makes agents effective.

## Requirements

### R1: Sandbox Environments

Production-like environment without real consequences.

```
# Good
Production: https://api.example.com
Sandbox:    https://sandbox.api.example.com

# Sandbox behavior
- Same endpoints and schemas
- Test data (not real users/payments)
- No real charges
- No external notifications
```

### R2: Test Mode Flags

Operations should support test/dry-run modes.

```yaml
# Good
POST /payments
{
  "amount": 1000,
  "currency": "USD",
  "test_mode": true  # No real charge
}

# Or via header
X-Test-Mode: true
```

### R3: Example Values in Schemas

Every property should have example values.

```yaml
# Good
properties:
  amount:
    type: integer
    minimum: 1
    example: 1000
  currency:
    type: string
    enum: [USD, EUR, GBP]
    example: USD
  email:
    type: string
    format: email
    example: "user@example.com"

# Bad - no examples
properties:
  amount:
    type: integer
  currency:
    type: string
```

### R4: Validation-Only Endpoints

Allow request validation without execution.

```yaml
# Good
POST /payments/validate
{
  "amount": 1000,
  "currency": "USD"
}

Response:
{
  "valid": true,
  "warnings": []
}

# Or via header
POST /payments
X-Validate-Only: true
```

### R5: Deterministic Test Data

Sandbox should return predictable data for testing.

```yaml
# Good - magic values trigger specific responses
POST /payments { "amount": 9999 }  # Always fails: INSUFFICIENT_FUNDS
POST /payments { "amount": 1 }     # Always succeeds
POST /payments { "amount": 500 }   # Always pending

# Document these test scenarios
x-ax-test-scenarios:
  - input: { "amount": 9999 }
    response: INSUFFICIENT_FUNDS
  - input: { "amount": 1 }
    response: SUCCESS
```

### R6: Sandbox Indication

Mark operations that are safe for sandbox testing.

```yaml
paths:
  /payments:
    post:
      x-ax-sandboxable: true  # Safe to call in sandbox

  /users/delete-all:
    delete:
      x-ax-sandboxable: false  # Dangerous even in sandbox
```

### R7: Rate Limits for Testing

Testing should have generous rate limits.

```yaml
# Good
Production: 100 requests/minute
Sandbox:    1000 requests/minute  # Higher for iteration

# Headers indicate limits
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 950
X-RateLimit-Reset: 1609459200
```

### R8: Mock Server from Spec

Spec should enable mock server generation.

```yaml
# Good - examples enable mocking
responses:
  '200':
    content:
      application/json:
        schema:
          $ref: '#/components/schemas/Payment'
        example:
          id: "pay_123"
          amount: 1000
          status: "completed"
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| No sandbox environment | Testing affects production | Create sandbox |
| Expensive test calls | Iteration costs add up | Free tier for testing |
| No example values | Can't generate test data | Add examples |
| Low rate limits | Can't iterate quickly | Higher limits for sandbox |
| Interactive-only testing | Agent can't automate | Programmatic test mode |
| No validation endpoint | Must execute to validate | Add validation mode |

## Free Tier Best Practices

| Aspect | Recommendation |
|--------|----------------|
| API calls | 10,000/month minimum |
| Rate limit | 100 requests/minute |
| Data retention | 7 days |
| Feature access | Full API (maybe reduced quotas) |
| Sign-up | Instant, no credit card |

## Enforcement

AX Spec rules:

- `ax-testable-sandboxable` - Operations should indicate sandbox safety
- `ax-testable-example-values` - Properties should have example values

## Example: Test Scenario Documentation

```yaml
paths:
  /payments:
    post:
      x-ax-sandboxable: true
      x-ax-test-scenarios:
        - name: successful_payment
          description: Payment succeeds
          request:
            amount: 1000
            currency: USD
          response:
            status: 201
            body:
              status: completed
        - name: insufficient_funds
          description: Payment fails due to insufficient funds
          request:
            amount: 9999999
            currency: USD
          response:
            status: 422
            body:
              error_code: INSUFFICIENT_FUNDS
        - name: invalid_currency
          description: Payment fails due to invalid currency
          request:
            amount: 1000
            currency: INVALID
          response:
            status: 400
            body:
              error_code: INVALID_CURRENCY
```

## Relationship to Other Principles

- **Deterministic** - Test data should be deterministic
- **Recoverable** - Test error paths to verify recovery
- **Explicit** - Test scenarios should be explicitly documented
- **Consistent** - Sandbox should behave consistently with production
