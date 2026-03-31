---
name: review-test-quality
description: Audit existing unit tests for quality, coverage gaps, and meaningful assertions. Activate when reviewing test suites, checking test quality, or investigating whether tests actually catch bugs.
---

# Review Test Quality

## When to Use

- Auditing an existing test suite for quality
- Investigating whether tests are meaningful (not just passing)
- Preparing a coverage gap analysis report
- Reviewing test code in a PR
- After a bug escaped to production (tests existed but didn't catch it)

## Audit Workflow

### 1. Coverage Analysis

Run the project's coverage tool and examine:
- Overall line coverage percentage
- Overall branch coverage percentage
- Files with zero coverage (completely untested)
- Files below the 80% minimum gate
- Files below the 95% target

### 2. Assertion Quality Check

For each test file, check:

**Are assertions meaningful?**
- Tests that only assert `toBeTruthy()` or `toBeDefined()` are weak
- Tests should assert specific values, not just existence
- Tests should verify the shape and content of return values

**Are error paths tested?**
- Every `try/catch`, `throw`, and `.catch()` in production code should have a corresponding test
- Error tests should verify the error type AND message

**Are edge cases covered?**
- Empty inputs
- Null/undefined handling
- Boundary values (0, -1, MAX_INT)
- Single vs multiple items in collections

**Are mocks properly verified?**
- If a mock is set up, is there an assertion that it was called?
- Are mock call arguments verified?
- Are mocks reset between tests?

### 3. Test Independence Check

Verify:
- No test relies on another test running first
- No shared mutable state between tests
- Each test can run in isolation (`it.only` should work for any test)
- No hardcoded dates, timestamps, or random values without seeding

### 4. Smell Detection

Flag these test smells:
- **The Giant**: Test with more than 30 lines — should be split
- **The Mockery**: More mocks than assertions — code may need refactoring
- **The Silent**: Test with no assertions — always passes, tests nothing
- **The Flicker**: Test that uses `setTimeout`, `Date.now()`, or `Math.random()` without control
- **The Copycat**: Duplicated test logic across multiple tests — use parameterized tests
- **The Skipper**: Tests marked with `skip`, `xit`, `xtest`, `@Disabled` — must have a fix plan
- **The Weakling**: Assertions using `toBeTruthy`, `toBeDefined`, `not.toBeNull` when specific values are available

### 5. Mutation Testing Assessment

If mutation testing tools are available:
- Run mutation testing on critical modules
- Check mutation score (target: 80%+)
- Identify surviving mutants — these are places where tests don't catch changes
- Prioritize adding tests for surviving mutants in critical paths

### 6. Generate Reports

**Coverage Report** — save to `docs/test-reports/coverage/[timestamp].md` following the format in the test evidence policy.

**Gap Analysis** — save to `docs/test-reports/gap-analysis/[timestamp].md` following the format in the test evidence policy.

**Audit Log** — append entry to `docs/test-reports/audit-log.md`:
```
| [timestamp] | Gap Analysis | agent | Reviewed N test files, found N gaps, N smells |
```

## Output Format

When reporting findings, organize by severity:

**Critical** (must fix before merge):
- Untested modules with business logic
- Missing error path tests for critical functions
- Tests with no assertions

**High** (fix in current sprint):
- Files below 80% coverage
- Weak assertions on important return values
- Unverified mocks

**Medium** (fix when touching the file):
- Files between 80-95% coverage
- Missing edge case tests
- Test smells (giant, copycat)

**Low** (nice to have):
- Missing tests for utility functions
- Parameterization opportunities
- Test naming improvements
