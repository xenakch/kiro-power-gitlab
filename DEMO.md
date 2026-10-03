# GitLab Power — Self-Guided Demo

Welcome. This is a **self-running tour** of the GitLab Power for Kiro.
You don't need a presenter — just follow along, paste the prompts, and
compare what you get to the "What you should see" notes.

Everything here is **read-only**. The Power can read and explain GitLab
data, but it cannot comment, approve, trigger pipelines, or merge. You
can run this demo safely without changing anything in GitLab.

**Time:** ~10 minutes. **Pick your track** below based on your role, or
do them all.

---

## What you're looking at

| Piece | What it is |
|---|---|
| **MCP server** `gitlab` | The read-only connector to GitLab (config in `mcp.json`). Toolsets limited to `merge_requests,pipelines`; permission mode `readonly`. |
| **Skill** `review-merge-request` | Summarizes a merge request's changes, risks, and test coverage; checks review/merge readiness. |
| **Skill** `investigate-pipeline` | Diagnoses why a merge request's CI pipeline failed, using the actual job logs. |
| **The demo MR** | Merge request **!1** in `xenakch/kiro-power-gitlab-demo` — it deliberately contains a bug and a failing pipeline, so there's always something to find. |

The demo merge request in your browser (handy to compare against):
<https://gitlab.com/xenakch/kiro-power-gitlab-demo/-/merge_requests/1>

---

## Step 0 — Start the Power (one time)

**Linux / macOS**

```bash
cd /path/to/kiro-power-gitlab
./verify-token.sh      # confirms your token works (expect: valid, scope read_api)
./start.sh             # launches Kiro with the token loaded
```

**Windows (PowerShell)**

```powershell
cd C:\path\to\kiro-power-gitlab
.\verify-token.ps1
.\start.ps1
```

**You should see:** `verify-token` reports the token is valid, authenticated
as a username, with scope `read_api`. In Kiro's **MCP Servers** view, the
`gitlab` server shows as connected.

> Keeping your token outside the repo? Set `GITLAB_ENV_FILE` to its path
> first (e.g. `GITLAB_ENV_FILE=~/.config/kiro-power-gitlab/.env ./start.sh`).

---

## Step 1 — Warm up: prove the connection

Paste this:

> **List my open merge requests on GitLab.**

**You should see:** merge request **!1 — "Demo: investigate failing
addition test"** in `xenakch/kiro-power-gitlab-demo`. If you see it, the
MCP server is live and read-only access works. 🎉

---

## How to point the Power at a merge request

You can refer to a merge request in whichever way is easiest — the Power
understands all of these:

- **By number + project:** "merge request !1 in `xenakch/kiro-power-gitlab-demo`"
- **Just the number**, once the project is in context: "review !1"
- **By full URL** (paste it directly):
  `https://gitlab.com/xenakch/kiro-power-gitlab-demo/-/merge_requests/1`
- **By branch:** "the latest pipeline on branch `demo/addition-bug`"

If something's ambiguous, the Power will ask rather than guess.

---

## 🧑‍💻 Track A — For Developers

**Goal:** understand a change and find out why CI is red.

1. Review the change:
   > **Summarize what changed in merge request !1 of
   > `xenakch/kiro-power-gitlab-demo` and flag anything risky. Use the
   > review-merge-request skill.**

   *You should see:* one file changed — `calculator.js` — where `add`
   was switched from `a + b` to `a - b`. It flags the missing test
   coverage and that the pipeline is failing.

2. Diagnose the failure:
   > **Why did the pipeline for !1 fail? Use the investigate-pipeline skill.**

   *You should see:* it finds the failed job `test-calculator`, reads the
   log, and quotes the real assertion — expected `5`, got `-1` — then
   suggests the smallest fix (revert to `a + b`), **marked unverified
   until tested.**

3. Try the guardrail:
   > **Post a comment on !1 saying it's on hold.**

   *You should see:* a polite refusal — the Power is read-only by design —
   with an offer to draft the comment text for you to paste yourself.

**Also try:**
- "Is the latest pipeline on branch `demo/addition-bug` green?"
- "Show me the diff for `calculator.js` in !1."
- "What's the smallest change that would make the pipeline pass?"

---

## 🧪 Track B — For Testers / QA

**Goal:** connect the failing test to the behavior change.

1. Get the test picture:
   > **Give me the test report summary for the latest pipeline on
   > merge request !1 of `xenakch/kiro-power-gitlab-demo`.**

2. Read the evidence straight from CI:
   > **Read the failed job log for !1 and tell me exactly which test
   > failed and what the expected vs. actual values were.**

   *You should see:* test `adds two numbers` failed with
   `AssertionError: -1 !== 5` — expected `5`, actual `-1`.

3. Tie it back to the code:
   > **Does the failing test in !1 match the behavior change described
   > in the merge request?**

   *You should see:* yes — the MR says `add(2, 3)` should return 5, but
   the code now subtracts, producing `-1`, which is exactly what the test
   rejects.

**Also try:**
- "Were any tests added or updated in this merge request?"
- "List the changed files in !1 without the diffs."
- "If I fix the operator, which test should start passing?"

---

## 📊 Track C — For Business / Leads / PMs

**Goal:** status and shipping insight, no code reading required.

1. Readiness at a glance:
   > **Is merge request !1 in `xenakch/kiro-power-gitlab-demo` ready to
   > merge? Summarize in plain language.**

   *You should see:* not ready — CI is failing and there are no
   approvals — explained without jargon.

2. Pipeline health:
   > **How many pipelines failed on `demo/addition-bug` recently, and
   > what's the latest status?**

3. Shipping / deployment questions (great on real projects):
   > **What shipped in the most recent deployment of
   > `xenakch/kiro-power-gitlab-demo`?**

   *You should see:* for this demo there are no deployments yet — and the
   Power will say so plainly instead of inventing an answer. That honesty
   is the point.

**Also try:**
- "Give me a one-paragraph status update on !1 I can paste into Slack."
- "Who authored !1 and when?"
- "Are there any unresolved discussions on !1?"

---

## What makes a good answer (what to notice)

As you go, watch for these quality signals — they're the whole value:

- **Cites evidence.** It quotes the actual diff and the real CI log
  values (`expected 5, got -1`), not vague guesses.
- **Separates observed from assumed.** It tells you what it verified
  versus what it's inferring.
- **Marks fixes unverified.** A suggested fix is a hypothesis until the
  pipeline re-runs green — and it says so.
- **Stays read-only.** It refuses to comment, approve, or merge, and
  offers you draft text instead.
- **Admits gaps.** If data is missing (e.g. no deployments), it says so
  rather than fabricating.

---

## Expected-results cheat sheet

| Item | Expected |
|---|---|
| Demo MR | !1 "Demo: investigate failing addition test" |
| Project | `xenakch/kiro-power-gitlab-demo` |
| Branches | `demo/addition-bug` → `main` |
| The change | `calculator.js`: `return a + b;` → `return a - b;` |
| Pipeline | failed |
| Failed job | `test-calculator` (stage `test`) |
| Failing test | `adds two numbers` |
| Assertion | `AssertionError: -1 !== 5` (expected `5`, actual `-1`) |
| Suggested fix | revert to `a + b` (unverified until CI re-runs) |
| Approvals / discussions | none |

> Note: pipeline IDs and commit SHAs change if the branch is re-pushed.
> The *shape* of the result stays the same; just re-run the prompt to
> refresh the specifics.

---

## If something doesn't work

- **MR !1 not found / auth error:** your token may be missing or expired.
  Re-run `verify-token` (`.sh` or `.ps1`). Generate a fresh `read_api`
  token if needed and update `.env`.
- **MCP server not connected:** make sure you launched Kiro via
  `start.sh` / `start.ps1` (or otherwise exported
  `GITLAB_PERSONAL_ACCESS_TOKEN`) so the token is in the environment.
- **Different numbers than the cheat sheet:** the branch was probably
  re-pushed. That's fine — the Power reports the live state.

---

## One-line pitch to leave people with

> "Instead of clicking through merge request, pipeline, job, and log
> views, you ask a question — and the Power gathers the evidence and
> explains it, read-only and safe to share."

Enjoy the tour. When you're ready for the real thing, point the same
questions at your own project and merge requests.
