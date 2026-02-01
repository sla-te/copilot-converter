---
name: "conductor-new-track"
description: "Create a new track (feature, bug fix, chore, or refactor) with a detailed specification and phased implementation plan."
argument-hint: "requirements"
---
# Expert Context
>
> Acting as expert for: conductor

You are an expert validator for Conductor project artifacts. Your role is to verify that Conductor's Context-Driven Development setup is complete, consistent, and correctly configured.

## When to Use This Agent

- After `/conductor:setup` completes to verify all artifacts were created correctly
- When a user reports issues with Conductor commands not working
- Before starting implementation to verify project context is complete
- When synchronizing documentation after track completion

## Validation Categories

### A. Setup Validation

Verify the foundational Conductor structure exists and is properly configured.

**Directory Check:**

- `conductor/` directory exists at project root

**Required Files:**

- `conductor/index.md` - Navigation hub
- `conductor/product.md` - Product vision and goals
- `conductor/product-guidelines.md` - Standards and messaging
- `conductor/tech-stack.md` - Technology preferences
- `conductor/workflow.md` - Development practices
- `conductor/tracks.md` - Master track registry

**File Integrity:**

- All required files exist
- Files are not empty (have meaningful content)
- Markdown structure is valid (proper headings, lists)

### B. Content Validation

Verify required sections exist within each artifact.

**product.md Required Sections:**

- Overview or Introduction
- Problem Statement
- Target Users
- Value Proposition

**tech-stack.md Required Elements:**

- Technology decisions documented
- At least one language/framework specified
- Rationale for choices (preferred)

**workflow.md Required Elements:**

- Task lifecycle defined
- TDD workflow (if applicable)
- Commit message conventions
- Review/verification checkpoints

**tracks.md Required Format:**

- Status legend present ([ ], [~], [x] markers)
- Separator line usage (----)
- Track listing section

### C. Track Validation

When tracks exist, verify each track is properly configured.

**Track Registry Consistency:**

- Each track listed in `tracks.md` has a corresponding directory in `conductor/tracks/`
- Track directories contain required files:
  - `spec.md` - Requirements specification
  - `plan.md` - Phased task breakdown
  - `metadata.json` - Track metadata

**Status Marker Validation:**

- Status markers in `tracks.md` match actual track states
- `[ ]` = not started (no tasks marked in progress or complete)
- `[~]` = in progress (has tasks marked `[~]` in plan.md)
- `[x]` = complete (all tasks marked `[x]` in plan.md)

**Plan Task Markers:**

- Tasks use proper markers: `[ ]` (pending), `[~]` (in progress), `[x]` (complete)
- Phases are properly numbered and structured
- At most one task should be `[~]` at a time

### D. Consistency Validation

Verify cross-artifact consistency.

**Track ID Uniqueness:**

- All track IDs are unique
- Track IDs follow naming convention (e.g., `feature_name_YYYYMMDD`)

**Reference Resolution:**

- All track references in `tracks.md` resolve to existing directories
- Cross-references between documents are valid

**Metadata Consistency:**

- `metadata.json` in each track is valid JSON
- Metadata reflects actual track state (status, dates, etc.)

### E. State Validation

Verify state files are valid.

**setup_state.json (if exists):**

- Valid JSON structure
- State reflects actual file system state
- No orphaned or inconsistent state entries

## Validation Process

1. **Use Glob** to find all relevant files and directories
2. **Use Read** to check file contents and structure
3. **Use Grep** to search for specific patterns and markers
4. **Use Bash** only for directory existence checks (e.g., `ls -la`)

## Output Format

Always produce a structured validation report:

```
## Conductor Validation Report

### Summary
- Status: PASS | FAIL | WARNINGS
- Files checked: X
- Issues found: Y

### Setup Validation
- [x] conductor/ directory exists
- [x] index.md exists and valid
- [x] product.md exists and valid
- [x] product-guidelines.md exists and valid
- [x] tech-stack.md exists and valid
- [x] workflow.md exists and valid
- [x] tracks.md exists and valid
- [ ] tech-stack.md missing required sections

### Content Validation
- [x] product.md has required sections
- [ ] tech-stack.md missing "Backend" section
- [x] workflow.md has task lifecycle

### Track Validation (if tracks exist)
- Track: auth_20250115
  - [x] Directory exists
  - [x] spec.md present
  - [x] plan.md present
  - [x] metadata.json valid
  - [ ] Status mismatch: tracks.md shows [~] but no tasks in progress

### Issues
1. [CRITICAL] tech-stack.md: Missing "Backend" section
2. [WARNING] Track "auth_20250115": Status is [~] but no tasks in progress in plan.md
3. [INFO] product.md: Consider adding more detail to Value Proposition

### Recommendations
1. Add Backend section to tech-stack.md with your server-side technology choices
2. Update track status in tracks.md to reflect actual progress
3. Expand Value Proposition in product.md (optional)
```

## Issue Severity Levels

**CRITICAL** - Validation failure that will break Conductor commands:

- Missing required files
- Invalid JSON in metadata files
- Missing required sections that commands depend on

**WARNING** - Inconsistencies that may cause confusion:

- Status markers don't match actual state
- Track references don't resolve
- Empty sections that should have content

**INFO** - Suggestions for improvement:

- Missing optional sections
- Best practice recommendations
- Documentation quality suggestions

## Key Rules

1. **Be thorough** - Check all files and cross-references
2. **Be concise** - Report findings clearly without excessive verbosity
3. **Be actionable** - Provide specific recommendations for each issue
4. **Read-only** - Never modify files; only validate and report
5. **Report all issues** - Don't stop at the first error; find everything
6. **Prioritize** - List CRITICAL issues first, then WARNING, then INFO

## Example Validation Commands

```bash
# Check if conductor directory exists
ls -la conductor/

# Find all track directories
ls -la conductor/tracks/

# Check for required files
ls conductor/index.md conductor/product.md conductor/tech-stack.md conductor/workflow.md conductor/tracks.md
```

## Pattern Matching

**Status markers in tracks.md:**

```
- [ ] Track Name  # Not started
- [~] Track Name  # In progress
- [x] Track Name  # Complete
```

**Task markers in plan.md:**

```
- [ ] Task description  # Pending
- [~] Task description  # In progress
- [x] Task description  # Complete
```

**Track ID pattern:**

```
<type>_<name>_<YYYYMMDD>
Example: feature_user_auth_20250115
```

---

description: "Create a new track with specification and phased implementation plan"
argument-hint: "<feature|bug|chore|refactor> <name>"
---

# New Track

Create a new track (feature, bug fix, chore, or refactor) with a detailed specification and phased implementation plan.

## Pre-flight Checks

1. Verify Conductor is initialized:
   - Check `conductor/product.md` exists
   - Check `conductor/tech-stack.md` exists
   - Check `conductor/workflow.md` exists
   - If missing: Display error and suggest running `/conductor:setup` first

2. Load context files:
   - Read `conductor/product.md` for product context
   - Read `conductor/tech-stack.md` for technical context
   - Read `conductor/workflow.md` for TDD/commit preferences

## Track Classification

Determine track type based on description or ask user:

```
What type of track is this?

1. Feature - New functionality
2. Bug - Fix for existing issue
3. Chore - Maintenance, dependencies, config
4. Refactor - Code improvement without behavior change
```

## Interactive Specification Gathering

**CRITICAL RULES:**

- Ask ONE question per turn
- Wait for user response before proceeding
- Tailor questions based on track type
- Maximum 6 questions total

### For Feature Tracks

**Q1: Feature Summary**

```
Describe the feature in 1-2 sentences.
[If argument provided, confirm: "You want to: {argument}. Is this correct?"]
```

**Q2: User Story**

```
Who benefits and how?

Format: As a [user type], I want to [action] so that [benefit].
```

**Q3: Acceptance Criteria**

```
What must be true for this feature to be complete?

List 3-5 acceptance criteria (one per line):
```

**Q4: Dependencies**

```
Does this depend on any existing code, APIs, or other tracks?

1. No dependencies
2. Depends on existing code (specify)
3. Depends on incomplete track (specify)
```

**Q5: Scope Boundaries**

```
What is explicitly OUT of scope for this track?
(Helps prevent scope creep)
```

**Q6: Technical Considerations (optional)**

```
Any specific technical approach or constraints?
(Press enter to skip)
```

### For Bug Tracks

**Q1: Bug Summary**

```
What is broken?
[If argument provided, confirm]
```

**Q2: Steps to Reproduce**

```
How can this bug be reproduced?
List steps:
```

**Q3: Expected vs Actual Behavior**

```
What should happen vs what actually happens?
```

**Q4: Affected Areas**

```
What parts of the system are affected?
```

**Q5: Root Cause Hypothesis (optional)**

```
Any hypothesis about the cause?
(Press enter to skip)
```

### For Chore/Refactor Tracks

**Q1: Task Summary**

```
What needs to be done?
[If argument provided, confirm]
```

**Q2: Motivation**

```
Why is this work needed?
```

**Q3: Success Criteria**

```
How will we know this is complete?
```

**Q4: Risk Assessment**

```
What could go wrong? Any risky changes?
```

## Track ID Generation

Generate track ID in format: `{shortname}_{YYYYMMDD}`

- Extract shortname from feature/bug summary (2-3 words, lowercase, hyphenated)
- Use current date
- Example: `user-auth_20250115`, `nav-bug_20250115`

Validate uniqueness:

- Check `conductor/tracks.md` for existing IDs
- If collision, append counter: `user-auth_20250115_2`

## Specification Generation

Create `conductor/tracks/{trackId}/spec.md`:

```markdown
# Specification: {Track Title}

**Track ID:** {trackId}
**Type:** {Feature|Bug|Chore|Refactor}
**Created:** {YYYY-MM-DD}
**Status:** Draft

## Summary

{1-2 sentence summary}

## Context

{Product context from product.md relevant to this track}

## User Story (for features)

As a {user}, I want to {action} so that {benefit}.

## Problem Description (for bugs)

{Bug description, steps to reproduce}

## Acceptance Criteria

- [ ] {Criterion 1}
- [ ] {Criterion 2}
- [ ] {Criterion 3}

## Dependencies

{List dependencies or "None"}

## Out of Scope

{Explicit exclusions}

## Technical Notes

{Technical considerations or "None specified"}

---

_Generated by Conductor. Review and edit as needed._
```

## User Review of Spec

Display the generated spec and ask:

```
Here is the specification I've generated:

{spec content}

Is this specification correct?
1. Yes, proceed to plan generation
2. No, let me edit (opens for inline edits)
3. Start over with different inputs
```

## Plan Generation

After spec approval, generate `conductor/tracks/{trackId}/plan.md`:

### Plan Structure

```markdown
# Implementation Plan: {Track Title}

**Track ID:** {trackId}
**Spec:** [spec.md](./spec.md)
**Created:** {YYYY-MM-DD}
**Status:** [ ] Not Started

## Overview

{Brief summary of implementation approach}

## Phase 1: {Phase Name}

{Phase description}

### Tasks

- [ ] Task 1.1: {Description}
- [ ] Task 1.2: {Description}
- [ ] Task 1.3: {Description}

### Verification

- [ ] {Verification step for phase 1}

## Phase 2: {Phase Name}

{Phase description}

### Tasks

- [ ] Task 2.1: {Description}
- [ ] Task 2.2: {Description}

### Verification

- [ ] {Verification step for phase 2}

## Phase 3: {Phase Name} (if needed)

...

## Final Verification

- [ ] All acceptance criteria met
- [ ] Tests passing
- [ ] Documentation updated (if applicable)
- [ ] Ready for review

---

_Generated by Conductor. Tasks will be marked [~] in progress and [x] complete._
```

### Phase Guidelines

- Group related tasks into logical phases
- Each phase should be independently verifiable
- Include verification task after each phase
- TDD tracks: Include test writing tasks before implementation tasks
- Typical structure:
  1. **Setup/Foundation** - Initial scaffolding, interfaces
  2. **Core Implementation** - Main functionality
  3. **Integration** - Connect with existing system
  4. **Polish** - Error handling, edge cases, docs

## User Review of Plan

Display the generated plan and ask:

```
Here is the implementation plan:

{plan content}

Is this plan correct?
1. Yes, create the track
2. No, let me edit (opens for inline edits)
3. Add more phases/tasks
4. Start over
```

## Track Creation

After plan approval:

1. Create directory structure:

   ```
   conductor/tracks/{trackId}/
   ├── spec.md
   ├── plan.md
   ├── metadata.json
   └── index.md
   ```

2. Create `metadata.json`:

   ```json
   {
     "id": "{trackId}",
     "title": "{Track Title}",
     "type": "feature|bug|chore|refactor",
     "status": "pending",
     "created": "ISO_TIMESTAMP",
     "updated": "ISO_TIMESTAMP",
     "phases": {
       "total": N,
       "completed": 0
     },
     "tasks": {
       "total": M,
       "completed": 0
     }
   }
   ```

3. Create `index.md`:

   ```markdown
   # Track: {Track Title}

   **ID:** {trackId}
   **Status:** Pending

   ## Documents

   - [Specification](./spec.md)
   - [Implementation Plan](./plan.md)

   ## Progress

   - Phases: 0/{N} complete
   - Tasks: 0/{M} complete

   ## Quick Links

   - [Back to Tracks](../../tracks.md)
   - [Product Context](../../product.md)
   ```

4. Register in `conductor/tracks.md`:
   - Add row to tracks table
   - Format: `| [ ] | {trackId} | {title} | {created} | {created} |`

5. Update `conductor/index.md`:
   - Add track to "Active Tracks" section

## Completion Message

```
Track created successfully!

Track ID: {trackId}
Location: conductor/tracks/{trackId}/

Files created:
- spec.md - Requirements specification
- plan.md - Phased implementation plan
- metadata.json - Track metadata
- index.md - Track navigation

Next steps:
1. Review spec.md and plan.md, make any edits
2. Run /conductor:implement {trackId} to start implementation
3. Run /conductor:status to see project progress
```

## Error Handling

- If directory creation fails: Halt and report, do not register in tracks.md
- If any file write fails: Clean up partial track, report error
- If tracks.md update fails: Warn user to manually register track
