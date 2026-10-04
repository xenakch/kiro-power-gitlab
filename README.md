# GitLab Power for Kiro

A community Kiro Power for reviewing GitLab merge requests
and diagnosing CI pipeline failures, using read-only tools.

> Source code is hosted on GitHub; the Power connects to GitLab
> (`gitlab.com` by default, configurable via `GITLAB_API_URL`).

## Status

Under development (version 0.1.0). Read-only GitLab access is working.
Works cross-platform (Linux, macOS, and Windows) using `npx`.

## What it does

The Power turns GitLab investigation into a conversation. Instead of
clicking through merge request, pipeline, job, and log views, you ask a
question and the agent gathers the evidence and explains it.

Everything is read-only. The Power can read and report, but it cannot
edit files, post comments, approve, trigger pipelines, or merge. That
makes it safe to share across a team.

## Skills

- **investigate-pipeline** — Diagnose why a merge request's CI pipeline
  failed: what changed, which job failed, what the logs prove, and the
  smallest suggested fix (marked unverified until tested).
- **review-merge-request** — Summarize a merge request's changes, risk
  areas, and test coverage, and check review and merge readiness.

## Try it: self-guided demo

New here? Take the self-running tour. No presenter needed — follow the
prompts and compare against the "what you should see" notes.

- [DEMO.md](DEMO.md) — overview tour with role tracks and a warm-up.
- Role-specific walkthroughs:
  - [Developer](demos/DEMO-developer.md)
  - [QA / Tester](demos/DEMO-qa.md)
  - [Manager / Lead / Business](demos/DEMO-manager.md)

The demo uses a public example merge request that deliberately contains a
bug and a failing pipeline, so there is always something to find.

## Example prompts

### For developers

- "Why did merge request !42 in `mygroup/myproject` fail? Use the
  investigate-pipeline skill."
- "Summarize what changed in merge request !42 and flag the risky parts."
- "Is the latest pipeline on branch `feature/login` green?"

### For QA engineers

- "Give me the test report summary for the latest pipeline on
  merge request !42."
- "Does the failing test in merge request !42 match the behavior change
  described in the merge request?"
- "Read the JUnit artifact from the failed job and summarize the failures."

### For managers and leads

- "What shipped in the most recent production deployment of
  `mygroup/myproject`?"
- "How many pipelines failed on `main` this week?"
- "Did the nightly scheduled pipeline run and pass?"

You can also paste a full merge request URL instead of naming the
project and IID.

## Approach

The Power packages an existing community GitLab MCP connector for
connectivity and adds focused, read-only skills for review and
troubleshooting workflows. It is not a new GitLab MCP implementation.

## Installation

Prerequisites:

- Kiro IDE with Powers support.
- Node.js and npm available on the machine.
- A GitLab personal access token with the `read_api` scope. Read-only
  is sufficient; do not grant full `api`.

Setup:

1. Install the Power from this folder (Powers panel → Add Custom Power →
   Import power from a folder).
2. Provide your GitLab token. Copy `.env.example` to `.env` and set
   `GITLAB_PERSONAL_ACCESS_TOKEN`. The `.env` file is git-ignored, so the
   real token stays out of version control.
3. Launch Kiro from a shell that has the token in its environment. The
   token is read from the `GITLAB_PERSONAL_ACCESS_TOKEN` environment
   variable at launch; the MCP config does not read `.env` directly.
   The simplest way is the included wrapper, which loads `.env` and
   starts Kiro in one step:

   ```bash
   ./start.sh            # macOS/Linux; starts `kiro-cli chat`
   ```

   ```powershell
   .\start.ps1           # Windows PowerShell; starts `kiro-cli chat`
   ```

   The wrapper contains no secret — it only loads `.env` for the Kiro
   process it launches. Alternatively, set the token yourself before
   launching Kiro:

   ```bash
   set -a; . ./.env; set +a    # macOS/Linux: load and export vars from .env
   kiro-cli chat
   ```

   ```powershell
   # Windows PowerShell: load .env, then start Kiro
   Get-Content .env | Where-Object { $_ -match '=' } | ForEach-Object {
     $k,$v = $_ -split '=',2; Set-Item "Env:$k" $v }
   kiro-cli chat
   ```

   To keep the token file outside the repo, set `GITLAB_ENV_FILE` to the
   path of an `.env` elsewhere; the wrapper loads that instead of the
   repo-local `.env`. If unset, it defaults to the repo-local `.env`, so
   existing setups are unaffected.

   ```bash
   GITLAB_ENV_FILE=~/.config/kiro-power-gitlab/.env ./start.sh   # macOS/Linux
   ```

   ```powershell
   $Env:GITLAB_ENV_FILE = "$HOME\.config\kiro-power-gitlab\.env"  # Windows PowerShell
   .\start.ps1
   ```

4. Confirm the GitLab server shows as connected in the MCP Servers view.
   You can verify the token itself with `./verify-token.sh` (macOS/Linux)
   or `.\verify-token.ps1` (Windows PowerShell).

   `verify-token.ps1` reads the token from the current shell's
   environment, and a bare PowerShell session does not load `.env`
   automatically. If `.\verify-token.ps1` reports `HTTP 401` even though
   the token in `.env` is valid, your shell is holding a stale or empty
   token. Load `.env` into the current session first, then verify:

   ```powershell
   # Windows PowerShell: load .env into the current session, then verify
   Get-Content .\.env | Where-Object { $_ -match '=' -and $_ -notmatch '^\s*#' } | ForEach-Object {
     $k,$v = $_ -split '=',2
     Set-Item "Env:$($k.Trim())" $v.Trim()
   }
   .\verify-token.ps1
   ```

## Security

- The token grants read access to GitLab. Use `read_api` scope only,
  set an expiration, and rotate it periodically.
- Never commit a real token. `.env` is git-ignored; `.env.example`
  holds placeholders only.
- CI job logs and merge request text are treated as untrusted data,
  not as instructions.

## License

Released under the [MIT License](LICENSE). Copyright (c) 2026 Christos
Xenakidis.

## Affiliation

This is an independent community project.
It is not an official Kiro or GitLab product.
