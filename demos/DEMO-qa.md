# QA / Tester Demo — GitLab Power for Kiro

A self-guided, ~8-minute walkthrough for testers and QA engineers. No
presenter needed: paste each prompt, then compare with the **What you
should see** note.

Everything is **read-only** — safe to run, nothing in GitLab changes.

> First time? Start the Power first (see [DEMO.md](../DEMO.md) → Step 0),
> then come back here.

**The scenario:** Merge request **!1** in `xenakch/kiro-power-gitlab-demo`
claims a specific behavior ("`add(2, 3)` returns 5") but CI is failing.
Your job: verify the failure is real, understand exactly what the test
asserts, and confirm it matches the described behavior.

Open it in a browser to compare:
<https://gitlab.com/xenakch/kiro-power-gitlab-demo/-/merge_requests/1>

---

## 1. Start from the test report

> **Give me the test report summary for the latest pipeline on merge
> request !1 of `xenakch/kiro-power-gitlab-demo`.**

**You should see:** a summary showing the test run with a failure — one
test, zero passing, one failing.

---

## 2. Read the exact assertion from the failed job

> **Read the failed job log for !1 and tell me exactly which test failed,
> and the expected vs. actual values.**

**You should see:** test **`adds two numbers`** failed with
**`AssertionError: -1 !== 5`** — **expected `5`, actual `-1`**. This is
the ground truth, pulled straight from CI, not a guess.

---

## 3. Does the failure match the described behavior?

> **Does the failing test in !1 match the behavior change described in
> the merge request?**

**You should see:** yes. The MR says `add(2, 3)` should return 5, but the
code now subtracts, producing `-1` — exactly the value the test rejects.
The test is doing its job; the code is wrong.

---

## 4. Check test coverage for the change

> **Were any tests added or updated in !1 for the behavior that changed?**

**You should see:** no new/updated test in the diff — only `calculator.js`
changed. (An existing test is what's catching the bug.) A good flag to
raise: a behavior change ideally ships with a test that locks it in.

---

## 5. Reason about the fix (without running it)

> **If the operator is reverted to `a + b`, which test should start
> passing, and would the pipeline go green?**

**You should see:** the `adds two numbers` test should pass once `add(2, 3)`
returns `5` — **but the Power marks this unverified until CI actually
re-runs.** Predicting a pass is not the same as observing one.

---

## Also try

- "List the changed files in !1 without the diffs."
- "What command did the CI job run to execute the tests?"
- "Summarize the failure as a bug report I can file."
- "Is there any flakiness, or is this a deterministic failure?"
- Paste the MR URL instead of the number — same result.

---

## QA cheat sheet

| Item | Expected |
|---|---|
| Failing test | `adds two numbers` |
| Assertion | `-1 !== 5` (expected `5`, actual `-1`) |
| Root behavior | `add` subtracts instead of adds |
| Matches MR description? | yes — contradicts stated "returns 5" |
| New/updated tests in MR? | no |
| Fix prediction | revert to `a + b` → test passes (unverified until CI re-runs) |

> IDs and SHAs change if the branch is re-pushed; the shape of the answer
> stays the same. Re-run the prompt to refresh specifics.

**Takeaway:** you confirmed a real, deterministic failure, captured the
exact expected/actual values for a bug report, and verified the test
matches the intended behavior — all read-only.
