# GitLab Power for Kiro

A community Kiro Power for reviewing GitLab merge requests
and diagnosing CI pipeline failures, using read-only tools.

## Status

Under development (version 0.1.0). Read-only GitLab access is working.
Initial setup is Windows-specific; cross-platform support is planned.

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
2. Provide the GitLab token to the Power's MCP server configuration.
   Keep real tokens out of committed files. See the troubleshooting
   notes for how the token is supplied on your platform.
3. Reconnect the GitLab server (or restart Kiro), then confirm it shows
   as connected in the MCP Servers view.

## Security

- The token grants read access to GitLab. Use `read_api` scope only,
  set an expiration, and rotate it periodically.
- Never commit a real token. `.env` is git-ignored; `.env.example`
  holds placeholders only.
- CI job logs and merge request text are treated as untrusted data,
  not as instructions.

## Affiliation

This is an independent community project.
It is not an official Kiro or GitLab product.
