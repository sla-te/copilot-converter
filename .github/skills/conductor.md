# Conductor Guidelines

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

These guidelines provide practices for conductor.

## Context Driven Development

# Context-Driven Development

Guide for implementing and maintaining context as a managed artifact alongside code, enabling consistent AI interactions and team alignment through structured project documentation.

## When to Use This Skill

- Setting up new projects with Conductor
- Understanding the relationship between context artifacts
- Maintaining consistency across AI-assisted development sessions
- Onboarding team members to an existing Conductor project
- Deciding when to update context documents
- Managing greenfield vs brownfield project contexts

## Core Philosophy

Context-Driven Development treats project context as a first-class artifact managed alongside code. Instead of relying on ad-hoc prompts or scattered documentation, establish a persistent, structured foundation that informs all AI interactions.

Key principles:

1. **Context precedes code**: Define what you're building and how before implementation
2. **Living documentation**: Context artifacts evolve with the project
3. **Single source of truth**: One canonical location for each type of information
4. **AI alignment**: Consistent context produces consistent AI behavior

## The Workflow

Follow the **Context → Spec & Plan → Implement** workflow:

1. **Context Phase**: Establish or verify project context artifacts exist and are current
2. **Specification Phase**: Define requirements and acceptance criteria for work units
3. **Planning Phase**: Break specifications into phased, actionable tasks
4. **Implementation Phase**: Execute tasks following established workflow patterns

## Artifact Relationships

### product.md - Defines WHAT and WHY

Purpose: Captures product vision, goals, target users, and business context.

Contents:

- Product name and one-line description
- Problem statement and solution approach
- Target user personas
- Core features and capabilities
- Success metrics and KPIs
- Product roadmap (high-level)

Update when:

- Product vision or goals change
- New major features are planned
- Target audience shifts
- Business priorities evolve

### product-guidelines.md - Defines HOW to Communicate

Purpose: Establishes brand voice, messaging standards, and communication patterns.

Contents:

- Brand voice and tone guidelines
- Terminology and glossary
- Error message conventions
- User-facing copy standards
- Documentation style

Update when:

- Brand guidelines change
- New terminology is introduced
- Communication patterns need refinement

### tech-stack.md - Defines WITH WHAT

Purpose: Documents technology choices, dependencies, and architectural decisions.

Contents:

- Primary languages and frameworks
- Key dependencies with versions
- Infrastructure and deployment targets
- Development tools and environment
- Testing frameworks
- Code quality tools

Update when:

- Adding new dependencies
- Upgrading major versions
- Changing infrastructure
- Adopting new tools or patterns

### workflow.md - Defines HOW to Work

Purpose: Establishes development practices, quality gates, and team workflows.

Contents:

- Development methodology (TDD, etc.)
- Git workflow and commit conventions
- Code review requirements
- Testing requirements and coverage targets
- Quality assurance gates
- Deployment procedures

Update when:

- Team practices evolve
- Quality standards change
- New workflow patterns are adopted

### tracks.md - Tracks WHAT'S HAPPENING

Purpose: Registry of all work units with status and metadata.

Contents:

- Active tracks with current status
- Completed tracks with completion dates
- Track metadata (type, priority, assignee)
- Links to individual track directories

Update when:

- New tracks are created
- Track status changes
- Tracks are completed or archived

## Context Maintenance Principles

### Keep Artifacts Synchronized

Ensure changes in one artifact reflect in related documents:

- New feature in product.md → Update tech-stack.md if new dependencies needed
- Completed track → Update product.md to reflect new capabilities
- Workflow change → Update all affected track plans

### Update tech-stack.md When Adding Dependencies

Before adding any new dependency:

1. Check if existing dependencies solve the need
2. Document the rationale for new dependencies
3. Add version constraints
4. Note any configuration requirements

### Update product.md When Features Complete

After completing a feature track:

1. Move feature from "planned" to "implemented" in product.md
2. Update any affected success metrics
3. Document any scope changes from original plan

### Verify Context Before Implementation

Before starting any track:

1. Read all context artifacts
2. Flag any outdated information
3. Propose updates before proceeding
4. Confirm context accuracy with stakeholders

## Greenfield vs Brownfield Handling

### Greenfield Projects (New)

For new projects:

1. Run `/conductor:setup` to create all artifacts interactively
2. Answer questions about product vision, tech preferences, and workflow
3. Generate initial style guides for chosen languages
4. Create empty tracks registry

Characteristics:

- Full control over context structure
- Define standards before code exists
- Establish patterns early

### Brownfield Projects (Existing)

For existing codebases:

1. Run `/conductor:setup` with existing codebase detection
2. System analyzes existing code, configs, and documentation
3. Pre-populate artifacts based on discovered patterns
4. Review and refine generated context

Characteristics:

- Extract implicit context from existing code
- Reconcile existing patterns with desired patterns
- Document technical debt and modernization plans
- Preserve working patterns while establishing standards

## Benefits

### Team Alignment

- New team members onboard faster with explicit context
- Consistent terminology and conventions across the team
- Shared understanding of product goals and technical decisions

### AI Consistency

- AI assistants produce aligned outputs across sessions
- Reduced need to re-explain context in each interaction
- Predictable behavior based on documented standards

### Institutional Memory

- Decisions and rationale are preserved
- Context survives team changes
- Historical context informs future decisions

### Quality Assurance

- Standards are explicit and verifiable
- Deviations from context are detectable
- Quality gates are documented and enforceable

## Directory Structure

```
conductor/
├── index.md              # Navigation hub linking all artifacts
├── product.md            # Product vision and goals
├── product-guidelines.md # Communication standards
├── tech-stack.md         # Technology preferences
├── workflow.md           # Development practices
├── tracks.md             # Work unit registry
├── setup_state.json      # Resumable setup state
├── code_styleguides/     # Language-specific conventions
│   ├── python.md
│   ├── typescript.md
│   └── ...
└── tracks/
    └── <track-id>/
        ├── spec.md
        ├── plan.md
        ├── metadata.json
        └── index.md
```

## Context Lifecycle

1. **Creation**: Initial setup via `/conductor:setup`
2. **Validation**: Verify before each track
3. **Evolution**: Update as project grows
4. **Synchronization**: Keep artifacts aligned
5. **Archival**: Document historical decisions

## Context Validation Checklist

Before starting implementation on any track, validate context:

### Product Context

- [ ] product.md reflects current product vision
- [ ] Target users are accurately described
- [ ] Feature list is up to date
- [ ] Success metrics are defined

### Technical Context

- [ ] tech-stack.md lists all current dependencies
- [ ] Version numbers are accurate
- [ ] Infrastructure targets are correct
- [ ] Development tools are documented

### Workflow Context

- [ ] workflow.md describes current practices
- [ ] Quality gates are defined
- [ ] Coverage targets are specified
- [ ] Commit conventions are documented

### Track Context

- [ ] tracks.md shows all active work
- [ ] No stale or abandoned tracks
- [ ] Dependencies between tracks are noted

## Common Anti-Patterns

Avoid these context management mistakes:

### Stale Context

Problem: Context documents become outdated and misleading.
Solution: Update context as part of each track's completion process.

### Context Sprawl

Problem: Information scattered across multiple locations.
Solution: Use the defined artifact structure; resist creating new document types.

### Implicit Context

Problem: Relying on knowledge not captured in artifacts.
Solution: If you reference something repeatedly, add it to the appropriate artifact.

### Context Hoarding

Problem: One person maintains context without team input.
Solution: Review context artifacts in pull requests; make updates collaborative.

### Over-Specification

Problem: Context becomes so detailed it's impossible to maintain.
Solution: Keep artifacts focused on decisions that affect AI behavior and team alignment.

## Integration with Development Tools

### IDE Integration

Configure your IDE to display context files prominently:

- Pin conductor/product.md for quick reference
- Add tech-stack.md to project notes
- Create snippets for common patterns from style guides

### Git Hooks

Consider pre-commit hooks that:

- Warn when dependencies change without tech-stack.md update
- Remind to update product.md when feature branches merge
- Validate context artifact syntax

### CI/CD Integration

Include context validation in pipelines:

- Check tech-stack.md matches actual dependencies
- Verify links in context documents resolve
- Ensure tracks.md status matches git branch state

## Session Continuity

Conductor supports multi-session development through context persistence:

### Starting a New Session

1. Read index.md to orient yourself
2. Check tracks.md for active work
3. Review relevant track's plan.md for current task
4. Verify context artifacts are current

### Ending a Session

1. Update plan.md with current progress
2. Note any blockers or decisions made
3. Commit in-progress work with clear status
4. Update tracks.md if status changed

### Handling Interruptions

If interrupted mid-task:

1. Mark task as `[~]` with note about stopping point
2. Commit work-in-progress to feature branch
3. Document any uncommitted decisions in plan.md

## Best Practices

1. **Read context first**: Always read relevant artifacts before starting work
2. **Small updates**: Make incremental context changes, not massive rewrites
3. **Link decisions**: Reference context when making implementation choices
4. **Version context**: Commit context changes alongside code changes
5. **Review context**: Include context artifact reviews in code reviews
6. **Validate regularly**: Run context validation checklist before major work
7. **Communicate changes**: Notify team when context artifacts change significantly
8. **Preserve history**: Use git to track context evolution over time
9. **Question staleness**: If context feels wrong, investigate and update
10. **Keep it actionable**: Every context item should inform a decision or behavior

## Track Management

# Track Management

Guide for creating, managing, and completing Conductor tracks - the logical work units that organize features, bugs, and refactors through specification, planning, and implementation phases.

## When to Use This Skill

- Creating new feature, bug, or refactor tracks
- Writing or reviewing spec.md files
- Creating or updating plan.md files
- Managing track lifecycle from creation to completion
- Understanding track status markers and conventions
- Working with the tracks.md registry
- Interpreting or updating track metadata

## Track Concept

A track is a logical work unit that encapsulates a complete piece of work. Each track has:

- A unique identifier
- A specification defining requirements
- A phased plan breaking work into tasks
- Metadata tracking status and progress

Tracks provide semantic organization for work, enabling:

- Clear scope boundaries
- Progress tracking
- Git-aware operations (revert by track)
- Team coordination

## Track Types

### feature

New functionality or capabilities. Use for:

- New user-facing features
- New API endpoints
- New integrations
- Significant enhancements

### bug

Defect fixes. Use for:

- Incorrect behavior
- Error conditions
- Performance regressions
- Security vulnerabilities

### chore

Maintenance and housekeeping. Use for:

- Dependency updates
- Configuration changes
- Documentation updates
- Cleanup tasks

### refactor

Code improvement without behavior change. Use for:

- Code restructuring
- Pattern adoption
- Technical debt reduction
- Performance optimization (same behavior, better performance)

## Track ID Format

Track IDs follow the pattern: `{shortname}_{YYYYMMDD}`

- **shortname**: 2-4 word kebab-case description (e.g., `user-auth`, `api-rate-limit`)
- **YYYYMMDD**: Creation date in ISO format

Examples:

- `user-auth_20250115`
- `fix-login-error_20250115`
- `upgrade-deps_20250115`
- `refactor-api-client_20250115`

## Track Lifecycle

### 1. Creation (newTrack)

**Define Requirements**

1. Gather requirements through interactive Q&A
2. Identify acceptance criteria
3. Determine scope boundaries
4. Identify dependencies

**Generate Specification**

1. Create `spec.md` with structured requirements
2. Document functional and non-functional requirements
3. Define acceptance criteria
4. List dependencies and constraints

**Generate Plan**

1. Create `plan.md` with phased task breakdown
2. Organize tasks into logical phases
3. Add verification tasks after phases
4. Estimate effort and complexity

**Register Track**

1. Add entry to `tracks.md` registry
2. Create track directory structure
3. Generate `metadata.json`
4. Create track `index.md`

### 2. Implementation

**Execute Tasks**

1. Select next pending task from plan
2. Mark task as in-progress
3. Implement following workflow (TDD)
4. Mark task complete with commit SHA

**Update Status**

1. Update task markers in plan.md
2. Record commit SHAs for traceability
3. Update phase progress
4. Update track status in tracks.md

**Verify Progress**

1. Complete verification tasks
2. Wait for checkpoint approval
3. Record checkpoint commits

### 3. Completion

**Sync Documentation**

1. Update product.md if features added
2. Update tech-stack.md if dependencies changed
3. Verify all acceptance criteria met

**Archive or Delete**

1. Mark track as completed in tracks.md
2. Record completion date
3. Archive or retain track directory

## Specification (spec.md) Structure

```markdown
# {Track Title}

## Overview

Brief description of what this track accomplishes and why.

## Functional Requirements

### FR-1: {Requirement Name}

Description of the functional requirement.

- Acceptance: How to verify this requirement is met

### FR-2: {Requirement Name}

...

## Non-Functional Requirements

### NFR-1: {Requirement Name}

Description of the non-functional requirement (performance, security, etc.)

- Target: Specific measurable target
- Verification: How to test

## Acceptance Criteria

- [ ] Criterion 1: Specific, testable condition
- [ ] Criterion 2: Specific, testable condition
- [ ] Criterion 3: Specific, testable condition

## Scope

### In Scope

- Explicitly included items
- Features to implement
- Components to modify

### Out of Scope

- Explicitly excluded items
- Future considerations
- Related but separate work

## Dependencies

### Internal

- Other tracks or components this depends on
- Required context artifacts

### External

- Third-party services or APIs
- External dependencies

## Risks and Mitigations

| Risk             | Impact          | Mitigation          |
| ---------------- | --------------- | ------------------- |
| Risk description | High/Medium/Low | Mitigation strategy |

## Open Questions

- [ ] Question that needs resolution
- [x] Resolved question - Answer
```

## Plan (plan.md) Structure

```markdown
# Implementation Plan: {Track Title}

Track ID: `{track-id}`
Created: YYYY-MM-DD
Status: pending | in-progress | completed

## Overview

Brief description of implementation approach.

## Phase 1: {Phase Name}

### Tasks

- [ ] **Task 1.1**: Task description
  - Sub-task or detail
  - Sub-task or detail
- [ ] **Task 1.2**: Task description
- [ ] **Task 1.3**: Task description

### Verification

- [ ] **Verify 1.1**: Verification step for phase

## Phase 2: {Phase Name}

### Tasks

- [ ] **Task 2.1**: Task description
- [ ] **Task 2.2**: Task description

### Verification

- [ ] **Verify 2.1**: Verification step for phase

## Phase 3: Finalization

### Tasks

- [ ] **Task 3.1**: Update documentation
- [ ] **Task 3.2**: Final integration test

### Verification

- [ ] **Verify 3.1**: All acceptance criteria met

## Checkpoints

| Phase   | Checkpoint SHA | Date | Status  |
| ------- | -------------- | ---- | ------- |
| Phase 1 |                |      | pending |
| Phase 2 |                |      | pending |
| Phase 3 |                |      | pending |
```

## Status Marker Conventions

Use consistent markers in plan.md:

| Marker | Meaning     | Usage                       |
| ------ | ----------- | --------------------------- |
| `[ ]`  | Pending     | Task not started            |
| `[~]`  | In Progress | Currently being worked      |
| `[x]`  | Complete    | Task finished (include SHA) |
| `[-]`  | Skipped     | Intentionally not done      |
| `[!]`  | Blocked     | Waiting on dependency       |

Example:

```markdown
- [x] **Task 1.1**: Set up database schema `abc1234`
- [~] **Task 1.2**: Implement user model
- [ ] **Task 1.3**: Add validation logic
- [!] **Task 1.4**: Integrate auth service (blocked: waiting for API key)
- [-] **Task 1.5**: Legacy migration (skipped: not needed)
```

## Track Registry (tracks.md) Format

```markdown
# Track Registry

## Active Tracks

| Track ID                                         | Type    | Status      | Phase | Started    | Assignee   |
| ------------------------------------------------ | ------- | ----------- | ----- | ---------- | ---------- |
| [user-auth_20250115](tracks/user-auth_20250115/) | feature | in-progress | 2/3   | 2025-01-15 | @developer |
| [fix-login_20250114](tracks/fix-login_20250114/) | bug     | pending     | 0/2   | 2025-01-14 | -          |

## Completed Tracks

| Track ID                                       | Type  | Completed  | Duration |
| ---------------------------------------------- | ----- | ---------- | -------- |
| [setup-ci_20250110](tracks/setup-ci_20250110/) | chore | 2025-01-12 | 2 days   |

## Archived Tracks

| Track ID                                             | Reason     | Archived   |
| ---------------------------------------------------- | ---------- | ---------- |
| [old-feature_20241201](tracks/old-feature_20241201/) | Superseded | 2025-01-05 |
```

## Metadata (metadata.json) Fields

```json
{
  "id": "user-auth_20250115",
  "title": "User Authentication System",
  "type": "feature",
  "status": "in-progress",
  "priority": "high",
  "created": "2025-01-15T10:30:00Z",
  "updated": "2025-01-15T14:45:00Z",
  "started": "2025-01-15T11:00:00Z",
  "completed": null,
  "assignee": "@developer",
  "phases": {
    "total": 3,
    "current": 2,
    "completed": 1
  },
  "tasks": {
    "total": 12,
    "completed": 5,
    "in_progress": 1,
    "pending": 6
  },
  "checkpoints": [
    {
      "phase": 1,
      "sha": "abc1234",
      "date": "2025-01-15T13:00:00Z"
    }
  ],
  "dependencies": [],
  "tags": ["auth", "security"]
}
```

## Track Operations

### Creating a Track

1. Run `/conductor:new-track`
2. Answer interactive questions
3. Review generated spec.md
4. Review generated plan.md
5. Confirm track creation

### Starting Implementation

1. Read spec.md and plan.md
2. Verify context artifacts are current
3. Mark first task as `[~]`
4. Begin TDD workflow

### Completing a Phase

1. Ensure all phase tasks are `[x]`
2. Complete verification tasks
3. Wait for checkpoint approval
4. Record checkpoint SHA
5. Proceed to next phase

### Completing a Track

1. Verify all phases complete
2. Verify all acceptance criteria met
3. Update product.md if needed
4. Mark track completed in tracks.md
5. Update metadata.json

### Reverting a Track

1. Run `/conductor:revert`
2. Select track to revert
3. Choose granularity (track/phase/task)
4. Confirm revert operation
5. Update status markers

## Handling Track Dependencies

### Identifying Dependencies

During track creation, identify:

- **Hard dependencies**: Must complete before this track can start
- **Soft dependencies**: Can proceed in parallel but may affect integration
- **External dependencies**: Third-party services, APIs, or team decisions

### Documenting Dependencies

In spec.md, list dependencies with:

- Dependency type (hard/soft/external)
- Current status (available/pending/blocked)
- Resolution path (what needs to happen)

### Managing Blocked Tracks

When a track is blocked:

1. Mark blocked tasks with `[!]` and reason
2. Update tracks.md status
3. Document blocker in metadata.json
4. Consider creating dependency track if needed

## Track Sizing Guidelines

### Right-Sized Tracks

Aim for tracks that:

- Complete in 1-5 days of work
- Have 2-4 phases
- Contain 8-20 tasks total
- Deliver a coherent, testable unit

### Too Large

Signs a track is too large:

- More than 5 phases
- More than 25 tasks
- Multiple unrelated features
- Estimated duration > 1 week

Solution: Split into multiple tracks with clear boundaries.

### Too Small

Signs a track is too small:

- Single phase with 1-2 tasks
- No meaningful verification needed
- Could be a sub-task of another track
- Less than a few hours of work

Solution: Combine with related work or handle as part of existing track.

## Specification Quality Checklist

Before finalizing spec.md, verify:

### Requirements Quality

- [ ] Each requirement has clear acceptance criteria
- [ ] Requirements are testable
- [ ] Requirements are independent (can verify separately)
- [ ] No ambiguous language ("should be fast" → "response < 200ms")

### Scope Clarity

- [ ] In-scope items are specific
- [ ] Out-of-scope items prevent scope creep
- [ ] Boundaries are clear to implementer

### Dependencies Identified

- [ ] All internal dependencies listed
- [ ] External dependencies have owners/contacts
- [ ] Dependency status is current

### Risks Addressed

- [ ] Major risks identified
- [ ] Impact assessment realistic
- [ ] Mitigations are actionable

## Plan Quality Checklist

Before starting implementation, verify plan.md:

### Task Quality

- [ ] Tasks are atomic (one logical action)
- [ ] Tasks are independently verifiable
- [ ] Task descriptions are clear
- [ ] Sub-tasks provide helpful detail

### Phase Organization

- [ ] Phases group related tasks
- [ ] Each phase delivers something testable
- [ ] Verification tasks after each phase
- [ ] Phases build on each other logically

### Completeness

- [ ] All spec requirements have corresponding tasks
- [ ] Documentation tasks included
- [ ] Testing tasks included
- [ ] Integration tasks included

## Common Track Patterns

### Feature Track Pattern

```
Phase 1: Foundation
- Data models
- Database migrations
- Basic API structure

Phase 2: Core Logic
- Business logic implementation
- Input validation
- Error handling

Phase 3: Integration
- UI integration
- API documentation
- End-to-end tests
```

### Bug Fix Track Pattern

```
Phase 1: Reproduction
- Write failing test capturing bug
- Document reproduction steps

Phase 2: Fix
- Implement fix
- Verify test passes
- Check for regressions

Phase 3: Verification
- Manual verification
- Update documentation if needed
```

### Refactor Track Pattern

```
Phase 1: Preparation
- Add characterization tests
- Document current behavior

Phase 2: Refactoring
- Apply changes incrementally
- Maintain green tests throughout

Phase 3: Cleanup
- Remove dead code
- Update documentation
```

## Best Practices

1. **One track, one concern**: Keep tracks focused on a single logical change
2. **Small phases**: Break work into phases of 3-5 tasks maximum
3. **Verification after phases**: Always include verification tasks
4. **Update markers immediately**: Mark task status as you work
5. **Record SHAs**: Always note commit SHAs for completed tasks
6. **Review specs before planning**: Ensure spec is complete before creating plan
7. **Link dependencies**: Explicitly note track dependencies
8. **Archive, don't delete**: Preserve completed tracks for reference
9. **Size appropriately**: Keep tracks between 1-5 days of work
10. **Clear acceptance criteria**: Every requirement must be testable

## Workflow Patterns

# Workflow Patterns

Guide for implementing tasks using Conductor's TDD workflow, managing phase checkpoints, handling git commits, and executing the verification protocol that ensures quality throughout implementation.

## When to Use This Skill

- Implementing tasks from a track's plan.md
- Following TDD red-green-refactor cycle
- Completing phase checkpoints
- Managing git commits and notes
- Understanding quality assurance gates
- Handling verification protocols
- Recording progress in plan files

## TDD Task Lifecycle

Follow these 11 steps for each task:

### Step 1: Select Next Task

Read plan.md and identify the next pending `[ ]` task. Select tasks in order within the current phase. Do not skip ahead to later phases.

### Step 2: Mark as In Progress

Update plan.md to mark the task as `[~]`:

```markdown
- [~] **Task 2.1**: Implement user validation
```

Commit this status change separately from implementation.

### Step 3: RED - Write Failing Tests

Write tests that define the expected behavior before writing implementation:

- Create test file if needed
- Write test cases covering happy path
- Write test cases covering edge cases
- Write test cases covering error conditions
- Run tests - they should FAIL

Example:

```python
def test_validate_user_email_valid():
    user = User(email="test@example.com")
    assert user.validate_email() is True

def test_validate_user_email_invalid():
    user = User(email="invalid")
    assert user.validate_email() is False
```

### Step 4: GREEN - Implement Minimum Code

Write the minimum code necessary to make tests pass:

- Focus on making tests green, not perfection
- Avoid premature optimization
- Keep implementation simple
- Run tests - they should PASS

### Step 5: REFACTOR - Improve Clarity

With green tests, improve the code:

- Extract common patterns
- Improve naming
- Remove duplication
- Simplify logic
- Run tests after each change - they should remain GREEN

### Step 6: Verify Coverage

Check test coverage meets the 80% target:

```bash
pytest --cov=module --cov-report=term-missing
```

If coverage is below 80%:

- Identify uncovered lines
- Add tests for missing paths
- Re-run coverage check

### Step 7: Document Deviations

If implementation deviated from plan or introduced new dependencies:

- Update tech-stack.md with new dependencies
- Note deviations in plan.md task comments
- Update spec.md if requirements changed

### Step 8: Commit Implementation

Create a focused commit for the task:

```bash
git add -A
git commit -m "feat(user): implement email validation

- Add validate_email method to User class
- Handle empty and malformed emails
- Add comprehensive test coverage

Task: 2.1
Track: user-auth_20250115"
```

Commit message format:

- Type: feat, fix, refactor, test, docs, chore
- Scope: affected module or component
- Summary: imperative, present tense
- Body: bullet points of changes
- Footer: task and track references

### Step 9: Attach Git Notes

Add rich task summary as git note:

```bash
git notes add -m "Task 2.1: Implement user validation

Summary:
- Added email validation using regex pattern
- Handles edge cases: empty, no @, no domain
- Coverage: 94% on validation module

Files changed:
- src/models/user.py (modified)
- tests/test_user.py (modified)

Decisions:
- Used simple regex over email-validator library
- Reason: No external dependency for basic validation"
```

### Step 10: Update Plan with SHA

Update plan.md to mark task complete with commit SHA:

```markdown
- [x] **Task 2.1**: Implement user validation `abc1234`
```

### Step 11: Commit Plan Update

Commit the plan status update:

```bash
git add conductor/tracks/*/plan.md
git commit -m "docs: update plan - task 2.1 complete

Track: user-auth_20250115"
```

## Phase Completion Protocol

When all tasks in a phase are complete, execute the verification protocol:

### Identify Changed Files

List all files modified since the last checkpoint:

```bash
git diff --name-only <last-checkpoint-sha>..HEAD
```

### Ensure Test Coverage

For each modified file:

1. Identify corresponding test file
2. Verify tests exist for new/changed code
3. Run coverage for modified modules
4. Add tests if coverage < 80%

### Run Full Test Suite

Execute complete test suite:

```bash
pytest -v --tb=short
```

All tests must pass before proceeding.

### Generate Manual Verification Steps

Create checklist of manual verifications:

```markdown
## Phase 1 Verification Checklist

- [ ] User can register with valid email
- [ ] Invalid email shows appropriate error
- [ ] Database stores user correctly
- [ ] API returns expected response codes
```

### WAIT for User Approval

Present verification checklist to user:

```
Phase 1 complete. Please verify:
1. [ ] Test suite passes (automated)
2. [ ] Coverage meets target (automated)
3. [ ] Manual verification items (requires human)

Respond with 'approved' to continue, or note issues.
```

Do NOT proceed without explicit approval.

### Create Checkpoint Commit

After approval, create checkpoint commit:

```bash
git add -A
git commit -m "checkpoint: phase 1 complete - user-auth_20250115

Verified:
- All tests passing
- Coverage: 87%
- Manual verification approved

Phase 1 tasks:
- [x] Task 1.1: Setup database schema
- [x] Task 1.2: Implement user model
- [x] Task 1.3: Add validation logic"
```

### Record Checkpoint SHA

Update plan.md checkpoints table:

```markdown
## Checkpoints

| Phase   | Checkpoint SHA | Date       | Status   |
| ------- | -------------- | ---------- | -------- |
| Phase 1 | def5678        | 2025-01-15 | verified |
| Phase 2 |                |            | pending  |
```

## Quality Assurance Gates

Before marking any task complete, verify these gates:

### Passing Tests

- All existing tests pass
- New tests pass
- No test regressions

### Coverage >= 80%

- New code has 80%+ coverage
- Overall project coverage maintained
- Critical paths fully covered

### Style Compliance

- Code follows style guides
- Linting passes
- Formatting correct

### Documentation

- Public APIs documented
- Complex logic explained
- README updated if needed

### Type Safety

- Type hints present (if applicable)
- Type checker passes
- No type: ignore without reason

### No Linting Errors

- Zero linter errors
- Warnings addressed or justified
- Static analysis clean

### Mobile Compatibility

If applicable:

- Responsive design verified
- Touch interactions work
- Performance acceptable

### Security Audit

- No secrets in code
- Input validation present
- Authentication/authorization correct
- Dependencies vulnerability-free

## Git Integration

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:

- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code change without feature/fix
- `test`: Adding tests
- `docs`: Documentation
- `chore`: Maintenance

### Git Notes for Rich Summaries

Attach detailed notes to commits:

```bash
git notes add -m "<detailed summary>"
```

View notes:

```bash
git log --show-notes
```

Benefits:

- Preserves context without cluttering commit message
- Enables semantic queries across commits
- Supports track-based operations

### SHA Recording in plan.md

Always record the commit SHA when completing tasks:

```markdown
- [x] **Task 1.1**: Setup schema `abc1234`
- [x] **Task 1.2**: Add model `def5678`
```

This enables:

- Traceability from plan to code
- Semantic revert operations
- Progress auditing

## Verification Checkpoints

### Why Checkpoints Matter

Checkpoints create restore points for semantic reversion:

- Revert to end of any phase
- Maintain logical code state
- Enable safe experimentation

### When to Create Checkpoints

Create checkpoint after:

- All phase tasks complete
- All phase verifications pass
- User approval received

### Checkpoint Commit Content

Include in checkpoint commit:

- All uncommitted changes
- Updated plan.md
- Updated metadata.json
- Any documentation updates

### How to Use Checkpoints

For reverting:

```bash
# Revert to end of Phase 1
git revert --no-commit <phase-2-commits>...
git commit -m "revert: rollback to phase 1 checkpoint"
```

For review:

```bash
# See what changed in Phase 2
git diff <phase-1-sha>..<phase-2-sha>
```

## Handling Deviations

During implementation, deviations from the plan may occur. Handle them systematically:

### Types of Deviations

**Scope Addition**
Discovered requirement not in original spec.

- Document in spec.md as new requirement
- Add tasks to plan.md
- Note addition in task comments

**Scope Reduction**
Feature deemed unnecessary during implementation.

- Mark tasks as `[-]` (skipped) with reason
- Update spec.md scope section
- Document decision rationale

**Technical Deviation**
Different implementation approach than planned.

- Note deviation in task completion comment
- Update tech-stack.md if dependencies changed
- Document why original approach was unsuitable

**Requirement Change**
Understanding of requirement changes during work.

- Update spec.md with corrected requirement
- Adjust plan.md tasks if needed
- Re-verify acceptance criteria

### Deviation Documentation Format

When completing a task with deviation:

```markdown
- [x] **Task 2.1**: Implement validation `abc1234`
  - DEVIATION: Used library instead of custom code
  - Reason: Better edge case handling
  - Impact: Added email-validator to dependencies
```

## Error Recovery

### Failed Tests After GREEN

If tests fail after reaching GREEN:

1. Do NOT proceed to REFACTOR
2. Identify which test started failing
3. Check if refactoring broke something
4. Revert to last known GREEN state
5. Re-approach the implementation

### Checkpoint Rejection

If user rejects a checkpoint:

1. Note rejection reason in plan.md
2. Create tasks to address issues
3. Complete remediation tasks
4. Request checkpoint approval again

### Blocked by Dependency

If task cannot proceed:

1. Mark task as `[!]` with blocker description
2. Check if other tasks can proceed
3. Document expected resolution timeline
4. Consider creating dependency resolution track

## TDD Variations by Task Type

### Data Model Tasks

```
RED: Write test for model creation and validation
GREEN: Implement model class with fields
REFACTOR: Add computed properties, improve types
```

### API Endpoint Tasks

```
RED: Write test for request/response contract
GREEN: Implement endpoint handler
REFACTOR: Extract validation, improve error handling
```

### Integration Tasks

```
RED: Write test for component interaction
GREEN: Wire components together
REFACTOR: Improve error propagation, add logging
```

### Refactoring Tasks

```
RED: Add characterization tests for current behavior
GREEN: Apply refactoring (tests should stay green)
REFACTOR: Clean up any introduced complexity
```

## Working with Existing Tests

When modifying code with existing tests:

### Extend, Don't Replace

- Keep existing tests passing
- Add new tests for new behavior
- Update tests only when requirements change

### Test Migration

When refactoring changes test structure:

1. Run existing tests (should pass)
2. Add new tests for refactored code
3. Migrate test cases to new structure
4. Remove old tests only after new tests pass

### Regression Prevention

After any change:

1. Run full test suite
2. Check for unexpected failures
3. Investigate any new failures
4. Fix regressions before proceeding

## Checkpoint Verification Details

### Automated Verification

Run before requesting approval:

```bash
# Test suite
pytest -v --tb=short

# Coverage
pytest --cov=src --cov-report=term-missing

# Linting
ruff check src/ tests/

# Type checking (if applicable)
mypy src/
```

### Manual Verification Guidance

For manual items, provide specific instructions:

```markdown
## Manual Verification Steps

### User Registration

1. Navigate to /register
2. Enter valid email: test@example.com
3. Enter password meeting requirements
4. Click Submit
5. Verify success message appears
6. Verify user appears in database

### Error Handling

1. Enter invalid email: "notanemail"
2. Verify error message shows
3. Verify form retains other entered data
```

## Performance Considerations

### Test Suite Performance

Keep test suite fast:

- Use fixtures to avoid redundant setup
- Mock slow external calls
- Run subset during development, full suite at checkpoints

### Commit Performance

Keep commits atomic:

- One logical change per commit
- Complete thought, not work-in-progress
- Tests should pass after every commit

## Best Practices

1. **Never skip RED**: Always write failing tests first
2. **Small commits**: One logical change per commit
3. **Immediate updates**: Update plan.md right after task completion
4. **Wait for approval**: Never skip checkpoint verification
5. **Rich git notes**: Include context that helps future understanding
6. **Coverage discipline**: Don't accept coverage below target
7. **Quality gates**: Check all gates before marking complete
8. **Sequential phases**: Complete phases in order
9. **Document deviations**: Note any changes from original plan
10. **Clean state**: Each commit should leave code in working state
11. **Fast feedback**: Run relevant tests frequently during development
12. **Clear blockers**: Address blockers promptly, don't work around them
