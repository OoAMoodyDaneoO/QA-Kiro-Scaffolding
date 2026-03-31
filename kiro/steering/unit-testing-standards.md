---
inclusion: always
---

# Unit Testing Standards

These standards apply to all unit tests written in this project. Every developer and agent must follow these guidelines.

## Coverage Targets

- Goal: 95% line and branch coverage across the codebase
- Minimum gate: 80% — code below this threshold must not be merged
- Critical paths (auth, payments, data integrity, security): 95% minimum, no exceptions
- New code: must ship with tests that cover at least 95% of the new lines
- Coverage is measured by line coverage AND branch coverage — both matter

## Core Principles: FIRST

All unit tests must satisfy the FIRST principles:

- Fast: Tests must execute quickly. A single test should complete in under 100ms. The full suite should run in under 60 seconds for most projects.
- Isolated: Each test must be independent. No test should depend on the state left by another test. No shared mutable state between tests. Use setup/teardown to ensure clean state.
- Repeatable: Tests must produce the same result every time, regardless of environment, time of day, or execution order. No flaky tests. If a test is flaky, it must be fixed or removed.
- Self-validating: Tests must have a clear pass/fail result. No manual inspection of output. Every test must contain explicit assertions.
- Timely: Tests must be written alongside the code they test, not after. When writing a new function, write its tests in the same commit.

## Test Structure: AAA Pattern

Every test must follow the Arrange-Act-Assert pattern:

```
// Arrange — set up the test data and preconditions
// Act — execute the function or method under test
// Assert — verify the result matches expectations
```

Rules:
- Each section should appear exactly once per test
- Keep the Arrange section minimal — only set up what this specific test needs
- The Act section should be a single function call or operation
- The Assert section should verify one logical concept (may use multiple assertions if they test the same behavior)

## What Must Be Tested

- Every exported function and method
- Every public class method
- Every module's primary interface
- All error handling paths (throw, reject, error returns)
- Boundary conditions (empty inputs, null/undefined, zero, max values)
- State transitions in stateful components
- Data transformations and mappings
- Conditional logic branches (if/else, switch, ternary)

## What Should NOT Be Tested in Unit Tests

- Third-party library internals (trust the library, test your usage of it)
- Framework boilerplate (routing config, module declarations)
- Simple getters/setters with no logic
- Type definitions and interfaces
- Constants and configuration values
- Private implementation details — test through the public interface

## Mocking Guidelines

- Mock external dependencies (APIs, databases, file system, network)
- Do NOT mock the unit under test
- Do NOT mock simple value objects or data structures
- Prefer dependency injection over module-level mocking when possible
- Mock at the boundary, not deep inside the call chain
- Every mock must be verified — if you mock something, assert it was called correctly
- Avoid excessive mocking — if a test requires more than 3 mocks, consider whether the code needs refactoring

## Naming Conventions

Test names must describe the behavior being tested, not the implementation:

```
// Good
"returns empty array when input list is empty"
"throws ValidationError when email format is invalid"
"calculates total price including tax for multiple items"

// Bad
"test1"
"should work"
"handles the thing"
```

Pattern: `[unit] [scenario] [expected behavior]`

## Test File Organization

- Co-locate test files with source files using `.test.{ext}` or `.spec.{ext}` suffix
- Mirror the source directory structure if using a separate `tests/` directory
- Group related tests using `describe` blocks that match the module/class name
- Order tests from simple/happy path to complex/error cases

## Mutation Testing

Beyond coverage, use mutation testing to verify test quality:
- Mutation score target: 80% minimum
- Mutation testing validates that tests actually detect bugs, not just execute code
- A high coverage score with a low mutation score means tests are running code but not asserting meaningful behavior
- Run mutation testing periodically (at minimum before major releases)
- Common mutation testing tools: Stryker (JS/TS), mutmut (Python), PIT (Java)

## Language-Specific Guidance

### TypeScript / JavaScript
- Framework: Vitest or Jest
- Use `describe` / `it` blocks
- Prefer `toEqual` for deep equality, `toBe` for primitives
- Use `vi.fn()` or `jest.fn()` for mocks
- Use `beforeEach` for setup, `afterEach` for cleanup
- Type-check test files — don't use `any` in tests

### Python
- Framework: pytest
- Use `pytest.fixture` for setup
- Use `pytest.raises` for exception testing
- Use `unittest.mock.patch` or `pytest-mock` for mocking
- Use parametrize for testing multiple inputs
- Follow PEP 8 in test files

### Java
- Framework: JUnit 5 with Mockito
- Use `@BeforeEach` / `@AfterEach` for setup/teardown
- Use `@ParameterizedTest` for data-driven tests
- Use `assertThrows` for exception testing
- Use Mockito's `verify()` to check mock interactions
- Use AssertJ for fluent assertions

### Go
- Use the standard `testing` package
- Use table-driven tests for multiple scenarios
- Use `testify/assert` for cleaner assertions
- Use `testify/mock` or interfaces for mocking
- Name test functions `TestFunctionName_Scenario`

### C# / .NET
- Framework: xUnit or NUnit with Moq
- Use `[Fact]` for single tests, `[Theory]` with `[InlineData]` for parameterized
- Use `FluentAssertions` for readable assertions
- Use `Moq` for mocking interfaces
- Follow the `MethodName_Scenario_ExpectedBehavior` naming pattern
