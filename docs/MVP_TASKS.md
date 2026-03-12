# Material8 MVP Tasks

This document defines the execution order for the Material8 MVP.

## Product objective
Build a fast, reliable dashboard for non-earnings SEC 8-K filings. The dashboard should help analysts find material events quickly by excluding low-signal earnings noise, assigning topics, scoring importance, and presenting results in a dense, filterable feed.

---

## Milestone 1 — Repository scaffold and local environment

### Goals
Create the development foundation.

### Deliverables
- Monorepo or clearly structured repo layout
- Frontend app scaffold
- Backend app scaffold
- Docker Compose for local development
- Environment variable strategy
- Postgres and Redis containers
- Initial database migrations
- README with setup steps
- Basic test harness for frontend and backend

### Acceptance criteria
- Repo boots locally with documented commands
- Backend and frontend start successfully
- Database migrations run successfully
- At least one smoke test exists for each app

---

## Milestone 2 — SEC ingestion foundation

### Goals
Build the raw 8-K ingestion path.

### Deliverables
- SEC client with respectful rate limiting and configurable user agent
- Company / CIK universe support
- New filing detection for Form 8-K
- Filing metadata retrieval
- Primary document URL capture
- Raw filing storage
- Accession-number deduplication
- Ingestion run logging
- Retry handling for transient failures

### Acceptance criteria
- New 8-Ks can be detected and persisted
- Duplicate ingestion does not create duplicate filings
- Failed fetches retry appropriately
- Ingestion run history is stored

### Notes
Favor auditable and simple ingestion logic. Do not overengineer.

---

## Milestone 3 — Parsing and normalization

### Goals
Extract structure from raw filings.

### Deliverables
- Filing text cleaner / normalizer
- Item number extraction
- Exhibit extraction
- Amendment detection
- Cleaned text persistence
- Initial parsed metadata persistence

### Acceptance criteria
- Common 8-K item numbers are extracted reliably
- Exhibit references, including Exhibit 99.1, are captured
- Cleaned text is suitable for downstream rules
- Parsing tests cover common and edge cases

---

## Milestone 4 — Exclusion engine

### Goals
Exclude most earnings-related 8-K noise while retaining mixed filings with dominant material non-earnings events.

### Deliverables
- Rule-based exclusion engine
- Stored exclusion reason codes
- Exclusion status persistence
- Mixed-filing handling logic
- Fixture-based tests for earnings, non-earnings, and mixed examples

### Required logic
Exclude by default when the filing is primarily earnings-related, especially when signals include:
- Item 2.02
- Exhibit 99.1 earnings-release pattern
- terms like quarterly results, financial results, earnings release, EPS, revenue for the quarter

Do not automatically exclude when a stronger non-earnings signal dominates, such as:
- CEO/CFO changes
- major M&A or asset sale
- bankruptcy/distress
- auditor/accounting issues
- delisting/compliance events

### Acceptance criteria
- Classic earnings 8-Ks are excluded
- Obvious non-earnings 8-Ks are retained
- Mixed filings are handled better than naive keyword suppression
- Exclusion reason codes are stored

---

## Milestone 5 — Topic classification engine

### Goals
Assign a single primary topic plus optional secondary tags.

### Deliverables
- Fixed taxonomy implementation
- Rule-first topic mapping
- Secondary tag extraction
- Reason code persistence
- Clear fallback behavior for ambiguous cases
- Tests for major topic categories

### Allowed primary topics
- Normal / Other
- Compensation Change
- Shareholder Vote
- Director Change
- Executive Change
- Asset Acquisition
- Asset Sale
- Merger / Strategic Transaction
- Material Agreement
- Financing / Debt
- Securities Offering
- Bankruptcy / Restructuring
- Auditor / Accounting Issue
- Delisting / Exchange Compliance
- Guidance / Outlook
- Litigation / Regulatory
- Impairment / Write-Down
- Other Material Event

### Acceptance criteria
- Every included filing receives exactly one allowed primary topic
- Secondary tags are optional and controlled
- No freeform production labels appear
- Reason codes are stored

---

## Milestone 6 — Importance scoring

### Goals
Score included filings as low, medium, or high based on analyst relevance.

### Deliverables
- Rule-first importance scorer
- Reason code persistence
- Tests for high-signal and low-signal examples
- Stable scoring behavior for obvious cases

### High-importance examples
- CEO/CFO changes
- bankruptcy or restructuring
- auditor resignation or non-reliance
- major strategic transaction
- covenant breach or financing distress
- delisting/compliance shock
- guidance withdrawal / major outlook event

### Acceptance criteria
- Clear high-importance events score high
- Routine governance noise does not score high
- Reason codes explain the score

---

## Milestone 7 — Summary generation

### Goals
Generate concise, factual summaries for feed and detail use.

### Deliverables
- Short summary generation
- Long summary generation
- Structured output validation
- Guardrails against hallucinated facts
- Tests or validation checks for formatting and presence

### Requirements
Short summary:
- 25–60 words
- event + actor + likely relevance

Long summary:
- 80–180 words
- what happened
- who is involved
- timing
- likely business or governance relevance

### Acceptance criteria
- Summaries are concise and readable
- Summaries avoid boilerplate
- Summaries do not invent unsupported terms or figures

---

## Milestone 8 — Backend API

### Goals
Expose data for the dashboard and admin workflow.

### Deliverables
- GET /api/feed
- GET /api/feed/filters
- GET /api/filings/{id}
- GET /api/companies/search?q=
- POST /api/admin/filings/{id}/override
- POST /api/admin/filings/{id}/reprocess

### Feed requirements
- newest first
- cursor-based pagination
- filter support for ticker/company, sector, industry, market cap bucket, importance, topic, tag, item number, and date range
- preserve inclusion/exclusion state as filterable

### Acceptance criteria
- API supports dashboard workflows cleanly
- Pagination is stable
- Filters compose correctly
- Admin overrides persist correctly

---

## Milestone 9 — Frontend dashboard

### Goals
Build the analyst-facing dashboard.

### Deliverables
- Dashboard page
- Dense row-first feed view
- Optional tile view
- Filter sidebar / controls
- Ticker/company search
- Load-more pagination
- Filing detail page
- Direct SEC links
- Basic empty / loading / error states

### Row fields
- filing time
- ticker
- company name
- market cap bucket
- sector
- importance
- topic
- item numbers
- short summary

### Acceptance criteria
- Row view is default
- Feed is fast and easy to scan
- Filters persist while loading more
- Detail page is usable and links to SEC source

---

## Milestone 10 — Admin and QA tools

### Goals
Support manual correction and quality control.

### Deliverables
- Internal admin page or protected workflow
- Override topic
- Override importance
- Override include/exclude
- Add note
- Reprocess filing
- Audit history display

### Acceptance criteria
- Operators can correct classification mistakes
- Override history is visible
- Manual changes do not break the feed

---

## Milestone 11 — Observability and hardening

### Goals
Make the MVP reliable enough to test with real users.

### Deliverables
- Logging for ingestion and classification pipeline
- Basic metrics for latency and failures
- Queue depth / stale feed visibility
- Duplicate detection checks
- Readme or docs for operations
- Sensible indexes and query tuning

### Acceptance criteria
- Failures are diagnosable
- Feed staleness is detectable
- Performance is acceptable for analyst use

---

## Milestone 12 — QA dataset and evaluation workflow

### Goals
Create a repeatable evaluation process for trust.

### Deliverables
- Labeled fixture set or gold dataset starter
- Review rubric for include/exclude, topic, and importance
- Scripts or docs for running evaluation
- Summary of known weak spots

### Acceptance criteria
- There is a repeatable way to judge quality
- Mixed 8-K edge cases are represented
- Quality can be improved systematically

---

## Working rules for Codex
- Complete one milestone at a time unless explicitly told otherwise.
- Do not start the next milestone automatically if the current one is incomplete.
- For each milestone, state what is complete and what remains stubbed.
- Prefer explainable rules over opaque heuristics.
- Keep schema and API choices practical and auditable.