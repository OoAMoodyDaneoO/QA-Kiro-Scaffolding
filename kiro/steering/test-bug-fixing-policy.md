---
inclusion: always
---

# Test Failure & Bug Fixing Policy

This policy governs how test failures must be handled. The core rule: when a test fails, investigate the root cause and fix the right thing. Never rewrite a test just to make it pass.

## The Golden Rule

A failing test is a signal, not a problem to silence. Before changing any test code, you must determine whether the failure is caused by:

1. A bug in the production code (fix the code)
2. A bug in the test itself (fix the test)
3. A legitimate behavior change that the test hasn't been updated for (update the test with justification)

## Triage Workflow

When a test fails, follow this sequence:

### Step 1: Read the failure message
- What assertion failed?
- What was the expected value vs actual value?
- Which line of production code is involved?

### Step 2: Reproduce and isolate
- Run the failing test in isolation to confirm it's not a test ordering issue
- Check if the test was passing before the recent change
- Identify the exact commit or change that introduced the failure

### Step 3: Classify the failure

**Category A — Production code bug:**
- The test expectation is correct based on the requirements
- The production code is producing wrong output
- Action: Fix the production code. Do not touch the test.

**Category B — Test bug:**
- The test has a logic error (wrong setup, wrong assertion, wrong mock)
- The production code behavior is correct
- Action: Fix the test. Document what was wrong with the test.

**Category C — Intentional behavior change:**
- A requirement changed and the production code was updated accordingly
- The test reflects the old requirement
- Action: Update the test to match the new requirement. Add a comment explaining the change and reference the requirement or ticket.

**Category D — Flaky test:**
- The test passes sometimes and fails sometimes
- Usually caused by timing, ordering, or external dependencies
- Action: Fix the root cause of flakiness. If timing-related, use proper async patterns. If ordering-related, ensure proper isolation. Never skip or disable a flaky test without a plan to fix it.

## Prohibited Actions

- NEVER delete a failing test without understanding why it fails
- NEVER change assertions to match incorrect behavior
- NEVER add `skip`, `xit`, `xtest`, or `@Disabled` to silence a failure without a documented plan and timeline to fix it
- NEVER weaken assertions (e.g., changing `toEqual` to `toBeTruthy`) to make a test pass
- NEVER remove edge case tests because they're "too strict"
- NEVER mock away the problem — if a test fails because of a real dependency issue, fix the dependency handling

## Documentation Requirements

When fixing a test failure, document:
- The failure category (A, B, C, or D)
- The root cause
- What was fixed (code, test, or both)
- If a test was updated (Category C), reference the requirement change

This can be in the commit message, PR description, or inline comment.

## Regression Prevention

After fixing a bug found by a test:
- Ensure the fix is minimal and targeted
- Verify no other tests broke as a result of the fix
- Consider adding additional edge case tests if the bug reveals a gap
- Run the full test suite before considering the fix complete

## Code Review Checklist for Test Changes

When reviewing PRs that modify tests, verify:
- [ ] Test changes are justified (not just making red go green)
- [ ] If assertions changed, the new assertions match current requirements
- [ ] No tests were deleted without explanation
- [ ] No skip/disable annotations were added without a fix plan
- [ ] Coverage did not decrease
- [ ] New edge cases were added if a bug was found
