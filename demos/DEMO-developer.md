# Developer Demo — GitLab Power for Kiro

A self-guided, ~8-minute walkthrough for developers. No presenter needed:
paste each prompt, then compare with the **What you should see** note.

Everything is **read-only** — the Power reads and explains, but never
comments, approves, triggers, or merges. Run it without fear.

> First time? Start the Power first (see [DEMO.md](../DEMO.md) → Step 0),
> then come back here.

**The scenario:** A teammate opened merge request **!1** in
`xenakch/kiro-power-gitlab-demo`. CI is red. You've been asked to figure
out what broke and what the fix is — fast.

Open it in a browser to compare as you go:
<https://gitlab.com/xenakch/kiro-power-gitlab-demo/-/merge_requests/1>

---

## 1. Get oriented — what is this MR?

> **Give me the details of merge request !1 in
> `xenakch/kiro-power-gitlab-demo`: author, branches, and whether it's
> mergeable.**

**You should see:** MR !1 "Demo: investigate failing addition test",
branch `demo/addition-bug` → `main`, no approvals yet. Git reports it as
mergeable (no conflicts) — which is *not* the same as "CI passes."

---

## 2. Read the change

> **Summarize what changed in !1 and flag anything risky. Use the
> review-merge-request skill.**

**You should see:** one file changed — `calculator.js` — where `add` was
switched from `return a + b;` to `return a - b;`. It flags two risks:
the behavior contradicts the function's purpose, and **no test was
added/updated** for the change.

Follow-up to see the raw diff:

> **Show me the diff for `calculator.js` in !1.**

---

## 3. Diagnose the CI failure from the logs

> **Why did the pipeline for !1 fail? Use the investigate-pipeline skill.**

**You should see:** it locates the failed job **`test-calculator`**,
reads the job log, and quotes the real assertion — **expected `5`, got
`-1`** (`AssertionError: -1 !== 5`). It confirms the failing pipeline's
commit matches the MR head, so the failure reflects exactly this change.

---

## 4. Pin down the smallest fix

> **What's the smallest change that would make the pipeline pass?**

**You should see:** revert the operator — `return a - b;` back to
`return a + b;` — **marked unverified until the pipeline re-runs green.**
Notice it doesn't claim victory; a fix is a hypothesis until CI proves it.

---

## 5. Hit the guardrail (on purpose)

> **Post a comment on !1 saying "blocked until the operator is reverted."**

**You should see:** a polite refusal. The Power is read-only by design —
it will instead offer to draft the comment text so *you* can paste it on
the MR yourself.

---

## Also try

- "Is the latest pipeline on branch `demo/addition-bug` green?"
- "Which commit introduced the change in !1?"
- "List the changed files in !1 without the diffs."
- "If I revert to `a + b`, which test should start passing?"
- Paste the MR URL instead of the number — it works the same way.

---

## Developer cheat sheet

| Item | Expected |
|---|---|
| Change | `calculator.js`: `a + b` → `a - b` |
| Failed job | `test-calculator` (stage `test`) |
| Assertion | `-1 !== 5` (expected `5`, actual `-1`) |
| Fix | revert to `a + b` (unverified until CI re-runs) |
| Tests added? | no |
| Guardrail | refuses to comment/approve/merge |

> IDs and SHAs change if the branch is re-pushed; the shape of the answer
> stays the same. Re-run the prompt to refresh specifics.

**Takeaway:** you went from "CI is red" to root cause and a candidate fix
— backed by the actual log line — without leaving the chat or touching
GitLab.
