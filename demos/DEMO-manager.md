# Manager / Lead / Business Demo — GitLab Power for Kiro

A self-guided, ~7-minute walkthrough for leads, PMs, and business
stakeholders. **No code reading required.** Paste each prompt, then
compare with the **What you should see** note.

Everything is **read-only** — the Power reads and explains; it never
changes anything in GitLab.

> First time? Start the Power first (see [DEMO.md](../DEMO.md) → Step 0),
> or ask a teammate to launch it. Then come back here.

**The scenario:** You want a clear status on merge request **!1** in
`xenakch/kiro-power-gitlab-demo` — is it safe to ship? — without digging
through GitLab's screens yourself.

---

## 1. Plain-language readiness

> **Is merge request !1 in `xenakch/kiro-power-gitlab-demo` ready to
> merge? Explain in plain language, no jargon.**

**You should see:** not ready — the automated checks (CI) are failing and
no one has approved it yet. Explained in plain terms, with the "why."

---

## 2. A status update you can paste into Slack

> **Give me a one-paragraph status update on !1 that I can paste into
> Slack for non-engineers.**

**You should see:** a short, readable paragraph: what the change is meant
to do, that checks are currently failing, and that it needs a fix plus
review before it can ship.

---

## 3. Who and when

> **Who authored !1, when was it opened, and are there any open
> discussions on it?**

**You should see:** the author and open date, and that there are no
unresolved discussion threads yet.

---

## 4. Pipeline health

> **How many pipelines failed on branch `demo/addition-bug` recently, and
> what's the latest status?**

**You should see:** a count/summary of recent runs with the latest one
failing. Useful for spotting repeatedly-red branches.

---

## 5. What shipped — and honest gaps

> **What shipped in the most recent deployment of
> `xenakch/kiro-power-gitlab-demo`?**

**You should see:** for this demo there are **no deployments yet**, and
the Power will simply say so — rather than inventing an answer. That
honesty is a feature: on your real projects this same question lists what
actually went out.

---

## Also try

- "Summarize !1 for a non-technical stakeholder in two sentences."
- "What's the risk if we merged !1 as-is today?"
- "Give me a go / no-go recommendation for !1 with the reason."
- "Are there approvals required that haven't happened yet?"

---

## Business cheat sheet

| Question | Expected answer shape |
|---|---|
| Ready to merge? | No — CI failing, no approvals |
| Why not? | A change that breaks its own stated behavior; checks fail |
| Approvals / discussions | none yet |
| Latest pipeline | failed |
| Most recent deployment | none yet (stated honestly) |
| Go / no-go | No-go until fixed and reviewed |

> Specifics (IDs, timestamps) may shift if the branch is re-pushed; the
> shape of the answer stays the same.

**Takeaway:** you got a trustworthy, plain-language read on shipping
readiness — including an honest "no data yet" where it applies — without
reading a single line of code or clicking through GitLab.
