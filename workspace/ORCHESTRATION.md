# ORCHESTRATION.md

This document is the always-on protocol for **serious / project work**.

This is **not** for tiny one-off scripts, quick greps, or trivial edits.

"Serious / project work" means: multi-step tasks, iterative work, derived artefacts (plots/geometry/results), method constraints ("must do X"), or anything your human will review.

## The Loop (always follow for serious/project work)

0) **TODO (checklist)**
- Write a short TODO checklist before doing work (in the project KG).
- Update the TODO as reality changes; do not silently drift.

1) **Spec** (KG)
- Create/update the project spec in `kg/SPEC.md`.
- Record *hard constraints* and *method constraints* explicitly.
- Record unknowns in `kg/OPEN_QUESTIONS.md` (do not guess).
- Record **parameter provenance**:
  - for each parameter, mark it as either:
    - **source-backed** (cite where it came from: paper/URL/file path/measurement note)
    - **free parameter** (explicitly declared as tunable; include current value + intended range)

2) **Delegate (default) / Implement (only for small tasks)**
- Default for serious work: delegate implementation to a builder subagent.
- Exception: small, low-risk glue/scripts may be implemented directly.
- If implementing directly, you still must satisfy the same spec/TODO/validation gates.

3) **Review (orchestrator)**
- Compare outputs against the spec + TODO.
- Decide **PASS / FAIL / BLOCKED**.

4) **Checker (often needed)**
Use a checker when complexity warrants, and **by default after any correction**.
- Checker does rote verification against the spec and simple sanity constraints.
- Checker does not extend scope.

5) **Ship**
Only ship outputs that are spec-compliant and checked (NL acceptance checks).

---

## Hard Gates

### Gate A — Method constraints cannot be downgraded
If `kg/SPEC.md` contains a method constraint (e.g. "must simulate folds"), then:
- Derived outputs that depend on that method (geometry/results/templates) are **forbidden** until the required capability is marked **VALIDATED** in `kg/CAPABILITIES.md`.
- **VALIDATED must include**: NL acceptance checks + how to rerun + known limitations (otherwise treat as not validated).
- While blocked, allowed outputs are limited to: spec/TODO updates, open questions, plan, delegation.

### Gate B — After a correction, stop shipping and re-ground
After the first "wrong / impossible / you ignored X":
- Freeze output shipping.
- Update `kg/SPEC.md` and `kg/OPEN_QUESTIONS.md`.
- Re-delegate.
- Prefer adding a checker until stability returns.

---

## Minimal Builder Output Contract (default expectation)

Unless you changed nothing, a builder response should include:
- **What changed** (files/paths)
- **How to rerun** (one command)
- **NL checks performed** (2–6 bullets)
- **Known gaps** (what is unverified / what might be wrong)

If you changed nothing, say **"No changes"**.

---

## Subagent Return Hook (always run, keep it short)
For every builder/checker response in project work, orchestrator must answer internally:
- What spec (path + last-updated) is this supposed to satisfy?
- Does it satisfy all hard/method constraints? (yes/no)
- What was checked (NL), what remains unverified?
- Decision: PASS / FAIL / BLOCKED, and next action.
