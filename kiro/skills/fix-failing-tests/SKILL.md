---
name: fix-failing-tests
description: Triage and fix failing unit tests following the bug fixing policy. Determines whether the failure is a code bug, test bug, or intentional change, then fixes the right thing. Activate when tests are failing or broken.
---

# Fix Failing Tests

## When to Use

- One or more unit tests are failing
- Tests broke after a code change
- CI pipeline is red due to test failures
- A flaky test needs investigation

## Triage Process

### Step 1: Identify the Failures

Run the test suite and collect:
- Which tests are failing
- The exact error messages and stack traces
- The expected vs actual values
- Which source files are involved

### Step 2: Classify Each Failure

For each failing test, determine the category:

**Category A — Production Code Bug**
Signs:
- The test assertion matches the documented requirement
- The production code is returning wrong values
- The test was passing before a recent code change
- The change that broke it modified production code, not test code

Action: Fix the production code. Do NOT modify the test.

**Category B — Test Bug**
Signs:
- The test setup is incorrect (wrong mock config, wrong input data)
- The assertion is checking the wrong thing
- The test has a logic error (testing the mock instead of the real code)
- The production code behavior is correct per requirements

Action: Fix the test. Add a comment explaining what was wrong.

**Category C — Intentional Behavior Change**
Signs:
- A requirement changed and production code was updated
- The test reflects the old requirement
- The PR/commit message mentions the behavior change

Action: Update the test to match the new requirement. Add a comment referencing the requirement change.

**Category D — Flaky Test**
Signs:
- The test passes sometimes, fails sometimes
- Involves timing (setTimeout, Date.now, async races)
- Involves ordering (depends on test execution order)
- Involves external state (file system, network, environment vars)

Action: Fix the root cause. Use proper async patterns, seed random values, ensure test isolation.

### Step 3: Fix the Right Thing

**For Category A (code bug):**
1. Read the failing test to understand the expected behavior
2. Read the production code to find the bug
3. Fix the production code
4. Run the failing test to confirm it passes
5. Run the full suite to confirm no regressions
6. Add additional edge case tests if the bug reveals a gap

**For Category B (test bug):**
1. Read the production code to understand correct behavior
2. Identify the error in the test (setup, assertion, or mock)
3. Fix the test
4. Add a comment: `// Fixed: [description of what was wrong]`
5. Run the test to confirm it passes

**For Category C (behavior change):**
1. Identify the requirement that changed
2. Update the test assertions to match new behavior
3. Add a comment: `// Updated: [requirement ref] — [description of change]`
4. Verify the test passes with the new assertions

**For Category D (flaky test):**
1. Run the test 10+ times to confirm flakiness
2. Identify the source of non-determinism
3. Fix it:
   - Timing: use fake timers or proper async/await
   - Ordering: ensure proper setup/teardown isolation
   - Randomness: seed the random generator
   - External state: mock the external dependency
4. Run the test 10+ times to confirm stability

### Step 4: Document

Append to `docs/test-reports/audit-log.md`:
```
| [timestamp] | Bug Fix | agent | Category [A/B/C/D]: [brief description of root cause and fix] |
```

## Prohibited Actions

These actions are NEVER acceptable:

- Changing an assertion to match wrong behavior
- Deleting a failing test
- Adding `.skip` or `@Disabled` without a documented fix plan
- Weakening assertions (e.g., `toEqual` → `toBeTruthy`)
- Removing edge case tests because they're "too strict"
- Mocking away the real problem
- Rewriting a test from scratch without understanding why it failed

## Escalation

If after investigation you cannot determine the correct category, or the fix is unclear:
- Document your findings so far
- Present the options to the developer with your analysis
- Let the developer make the call on which category applies
- Never guess — ask when uncertain
