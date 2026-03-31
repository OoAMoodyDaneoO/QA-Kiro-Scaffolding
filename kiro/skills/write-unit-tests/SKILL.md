---
name: write-unit-tests
description: Generate comprehensive unit tests for new or existing code following project testing standards (FIRST principles, AAA pattern, 95% coverage target). Activate when writing tests, adding test coverage, or creating test files.
---

# Write Unit Tests

## When to Use

- Writing tests for a new function, class, or module
- Adding test coverage to existing untested code
- Scaffolding a test file for a new source file
- Responding to a coverage gap identified in a report

## Workflow

### 1. Analyze the Source Code

Before writing any test, read and understand:
- What the function/module does (its contract)
- Its inputs, outputs, and side effects
- Its error handling paths
- Its dependencies (what needs mocking)
- Its boundary conditions

### 2. Plan Test Cases

For each function or method, identify:

**Happy path tests:**
- Typical input producing expected output
- Multiple valid input variations

**Edge case tests:**
- Empty inputs (empty string, empty array, null, undefined, 0)
- Maximum/minimum values
- Single-element collections
- Unicode, special characters (for string inputs)

**Error path tests:**
- Invalid input types
- Out-of-range values
- Missing required parameters
- Network/IO failures (for functions with external deps)

**State tests (if stateful):**
- Initial state
- State after operations
- State transitions
- Concurrent access (if applicable)

### 3. Write Tests Following Standards

Every test must follow the AAA pattern:

```
describe('ModuleName', () => {
  describe('functionName', () => {
    it('returns expected result when given valid input', () => {
      // Arrange
      const input = createValidInput();

      // Act
      const result = functionName(input);

      // Assert
      expect(result).toEqual(expectedOutput);
    });

    it('throws ValidationError when input is empty', () => {
      // Arrange
      const input = '';

      // Act & Assert
      expect(() => functionName(input)).toThrow(ValidationError);
    });
  });
});
```

### 4. Mock Only What's Necessary

- Mock external services, databases, file system, network calls
- Do NOT mock the unit under test
- Do NOT mock simple data objects
- Verify mock interactions (was it called? with what args?)
- Reset mocks between tests

### 5. Verify Coverage

After writing tests:
- Run the test suite to confirm all tests pass
- Check coverage for the specific file/module
- Ensure line and branch coverage meet the 95% target
- If below target, identify uncovered lines and add tests

### 6. Document in Audit Log

After adding tests, append an entry to `docs/test-reports/audit-log.md`:
```
| [timestamp] | Tests Added | agent | Added N tests for [module] — covers [description] |
```

## Quality Checklist

Before considering tests complete:
- [ ] Every exported function has at least one test
- [ ] Happy path covered
- [ ] At least 2 edge cases per function
- [ ] Error paths covered (every throw/reject has a test)
- [ ] All mocks are verified
- [ ] Test names describe behavior, not implementation
- [ ] No test depends on another test's state
- [ ] Tests run in under 100ms each
- [ ] Coverage meets 95% target for the file

## Anti-Patterns to Avoid

- Testing implementation details instead of behavior
- Asserting on mock call counts without asserting on results
- Using `any` or loose matchers when exact values are known
- Writing tests that always pass regardless of code changes
- Copying test code instead of using parameterized tests
- Testing trivial getters/setters with no logic
