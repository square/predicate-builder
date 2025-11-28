# ConsumptionTest

This package tests that PredicateBuilder can be consumed correctly through its public API.

## Purpose

This test verifies both positive and negative compilation cases:

**Positive Tests (ValidCode target):**
- Users only need to `import PredicateBuilder` (single import)
- The macro (`#PredicateBuilder`) is automatically available
- The result builder (`@PredicateBuilder`) works correctly
- All types and functionality are accessible through the single import

**Negative Tests (InvalidCode target):**
- Type checking works correctly - invalid code fails to compile
- Compiler errors are appropriate and prevent runtime crashes
- Type constraints are enforced through the public API

## Why This Exists

The main test suite uses `@testable import`, which bypasses public API boundaries and allows importing internal modules directly. This test uses only the public API, ensuring that:

1. The package structure is correct
2. Re-exports work as intended
3. The public API contract is maintained
4. Breaking changes to the public API are caught
5. Type checking works correctly through the public API
