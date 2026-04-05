# Consistent

> Agents build mental models once and apply them everywhere, scaling their effectiveness.

## Definition

An interface is **consistent** when it uses the same patterns, conventions, and structures throughout—allowing agents to generalize from one endpoint to all others.

## Why Agents Need It

- Uniform patterns across all APIs
- Agents learn rules once, apply everywhere
- Reduces cognitive load exponentially

Agents learn patterns. When they see:

- Pagination working one way on `/users`
- Pagination working differently on `/orders`
- A third way on `/products`

...they can't generalize. Each endpoint requires special handling.

Consistency lets agents build mental models that apply broadly.

## Requirements

### R1: Naming Conventions

Use consistent naming throughout.

```yaml
# Good - consistent snake_case
created_at
updated_at
user_id
order_items

# Bad - mixed conventions
createdAt      # camelCase
updated_at     # snake_case
userID         # inconsistent casing
orderItems     # camelCase again
```

### R2: Pagination Patterns

Use the same pagination approach everywhere.

```yaml
# Good - consistent offset pagination
GET /users?limit=20&offset=0
GET /orders?limit=20&offset=0
GET /products?limit=20&offset=0

# Response
{
  "data": [...],
  "pagination": {
    "total": 150,
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}

# Bad - mixed patterns
GET /users?limit=20&offset=0
GET /orders?page=1&per_page=20
GET /products?cursor=abc123
```

### R3: Error Response Format

Same error structure everywhere.

```yaml
# Good - consistent error shape
{
  "error_code": "RESOURCE_NOT_FOUND",
  "message": "User not found",
  "details": []
}

# Bad - different shapes
# Endpoint A
{ "error": "Not found" }

# Endpoint B
{ "code": 404, "msg": "Resource missing" }

# Endpoint C
{ "errors": [{ "type": "not_found" }] }
```

### R4: URL Structure

Predictable URL patterns.

```yaml
# Good - RESTful conventions
GET    /users           # List
POST   /users           # Create
GET    /users/{id}      # Get one
PUT    /users/{id}      # Update
DELETE /users/{id}      # Delete
GET    /users/{id}/orders  # Related resource

# Bad - inconsistent patterns
GET    /users           # List
POST   /user/create     # Create (different path)
GET    /getUser/{id}    # Get (verb in path)
POST   /users/{id}/update  # Update (POST not PUT)
```

### R5: Response Envelope

Consistent wrapper structure.

```yaml
# Good - consistent envelope
# Success
{
  "data": { ... },
  "meta": { "request_id": "..." }
}

# List
{
  "data": [ ... ],
  "pagination": { ... },
  "meta": { "request_id": "..." }
}

# Bad - inconsistent wrapping
# Some endpoints return raw object
{ "id": "123", "name": "..." }

# Others use envelope
{ "data": { "id": "123" } }

# Others use different key
{ "result": { "id": "123" } }
```

### R6: Parameter Naming

Same parameter names for same concepts.

```yaml
# Good - consistent parameter names
GET /users?limit=20&offset=0&sort=created_at&order=desc
GET /orders?limit=20&offset=0&sort=created_at&order=desc

# Bad - different names for same concept
GET /users?limit=20&offset=0
GET /orders?count=20&skip=0    # Different names!
GET /products?size=20&page=0   # Different pattern!
```

### R7: Content Types

Consistent content type usage.

```yaml
# Good - JSON everywhere
Content-Type: application/json
Accept: application/json

# Bad - mixed types
POST /users     Content-Type: application/json
POST /upload    Content-Type: multipart/form-data
POST /legacy    Content-Type: application/x-www-form-urlencoded
```

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|--------------|---------|-----|
| Mixed naming (camelCase + snake_case) | Can't predict field names | Pick one convention |
| Different pagination per endpoint | Custom handling per endpoint | Standardize |
| Inconsistent error shapes | Can't write generic error handler | Define schema |
| Verbs in URLs | Breaks REST conventions | Use HTTP methods |
| Different envelope keys | Can't extract data generically | Standardize wrapper |

## Conventions to Document

Choose and document these conventions:

| Aspect | Decision |
|--------|----------|
| Field naming | snake_case / camelCase |
| Timestamps | ISO 8601 / Unix epoch |
| IDs | UUID / integer / prefixed |
| Pagination | Offset / Cursor / Page |
| Null handling | Omit / Include as null |
| Date format | `date` / `date-time` |
| Boolean values | true/false / 1/0 |

## Enforcement

AX Spec rules:

- `ax-consistent-response-content-type` - Responses should use application/json
- `ax-consistent-pagination` - List operations should have consistent pagination

## Example: Pagination Consistency

### Before (Inconsistent)

```yaml
# /users
GET /users?limit=20&offset=0
Response: { "users": [...], "total": 100 }

# /orders
GET /orders?page=1&size=20
Response: { "data": [...], "page_info": { "current": 1, "total_pages": 5 } }

# /products
GET /products?cursor=abc
Response: { "items": [...], "next_cursor": "def" }
```

### After (Consistent)

```yaml
# All endpoints
GET /users?limit=20&offset=0
GET /orders?limit=20&offset=0
GET /products?limit=20&offset=0

# Same response shape
Response: {
  "data": [...],
  "pagination": {
    "total": 100,
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}
```

## Relationship to Other Principles

- **Deterministic** - Consistency enables predictable behavior
- **Explicit** - Conventions should be explicitly documented
- **Introspectable** - Consistent patterns are easier to discover
