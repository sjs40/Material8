# AGENTS.md

## Project
This repository contains Material8, an analyst-focused dashboard for SEC Form 8-K filings.

Material8 is not a generic filing viewer. It is a signal-ranking product for equity analysts and event-driven investors. The product should prioritize speed, clarity, reliability, and explainability over visual novelty.

## Product priorities
In order of importance:
1. Correctly exclude most earnings-related 8-K noise
2. Correctly surface high-signal non-earnings events
3. Keep the dashboard fast and dense for analyst scanning
4. Preserve explainability with stored reason codes
5. Maintain operational reliability and idempotence
6. Only then optimize polish and secondary UX details

## Standing rules
- Default to rule-first implementations for exclusion, topic classification, and importance scoring.
- Use fixed enums and controlled vocabularies. Do not introduce freeform production labels.
- Store explicit reason codes for exclusion, topic, and importance decisions.
- Make ingestion and classification idempotent.
- De-duplicate filings by accession number.
- Preserve direct links to original SEC filings.
- Prefer simple, auditable implementations over clever opaque ones.
- Do not silently change taxonomy, scoring rules, or schema semantics without documenting the reason.
- Do not trade analyst scan speed for decorative UI choices.

## UI guidance
- Row view is the default and primary experience.
- Tile view is optional and secondary.
- The feed should be newest first.
- Dense, scannable layouts are preferred.
- Important fields in the feed: filing time, ticker, company name, market cap bucket, sector, importance, topic, item numbers, summary.
- Filters must persist while paginating or loading more.
- Use cursor-based pagination, not page-number pagination.
- Make SEC source links obvious.

## Classification guidance
### Exclusion
Exclude classic earnings-related 8-Ks by default, especially when Item 2.02 is the main event.

Important exclusion signals:
- Item 2.02
- Exhibit 99.1 earnings-release pattern
- terms such as quarterly results, financial results, earnings release, EPS, revenue for the quarter

Do not automatically exclude a filing if a more material non-earnings event dominates, such as:
- CEO/CFO departure or appointment
- major asset acquisition/disposition
- merger / strategic transaction
- bankruptcy / restructuring / covenant distress
- auditor or accounting issue
- delisting / exchange compliance

### Primary topic taxonomy
Allowed primary topics:
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

### Secondary tags
Use optional secondary tags where supported, for example:
- CEO
- CFO
- Chair
- Board
- Special Committee
- Activist
- Tender Offer
- Credit Facility
- Covenant
- Amendment
- Restatement Risk
- Spin-off
- Divestiture
- Vote Passed
- Vote Failed

### Importance scoring
Use low / medium / high only.

High-importance examples:
- CEO or CFO change
- bankruptcy / restructuring
- auditor resignation or non-reliance / restatement risk
- major acquisition / sale / merger
- covenant breach / financing distress
- delisting or serious compliance event
- guidance withdrawal or major outlook shock

Medium-importance examples:
- director changes
- compensation changes
- shareholder vote results with moderate significance
- non-core asset transactions
- refinancing or debt amendments without clear distress
- securities offerings
- material litigation / regulatory updates

Low-importance examples:
- routine governance disclosures
- immaterial amendments
- low-signal Item 8.01 filings
- procedural or boilerplate items

## Implementation guidance
Preferred stack:
- Frontend: Next.js + TypeScript
- Backend: FastAPI + Python
- Database: Postgres
- Cache/queue: Redis
- Background jobs: Celery or RQ
- Local development: Docker Compose

Prefer:
- typed APIs
- explicit migrations
- clean service boundaries
- small, testable modules
- predictable configuration via environment variables

Avoid:
- premature microservices
- unnecessary vendor lock-in
- fragile implicit behavior
- hidden business logic in the frontend

## Performance expectations
Target practical MVP performance:
- fast initial feed load
- fast filtered queries
- predictable detail-page latency
- near-real-time appearance of newly discovered filings after processing

Optimize query patterns and indexes early enough that the feed stays usable.

## Testing requirements
Every milestone should include tests where meaningful.

Minimum coverage expectations:
- ingestion deduplication
- item number extraction
- earnings exclusion rules
- mixed filing handling
- topic classification for common items
- importance scoring for obvious high-signal cases
- API contract sanity
- pagination / filter persistence where practical

Add fixture cases for tricky mixed 8-Ks.

## Documentation requirements
Update README and relevant docs when:
- setup changes
- environment variables change
- schema changes
- commands change
- milestone status changes

## Execution behavior
Before major code changes:
- briefly state the plan

After completing a milestone:
- summarize what changed
- list commands to run
- list tests added
- state known gaps clearly
- do not claim production readiness if parts are stubbed or heuristic

## Source-of-truth behavior
When product rules conflict with implementation convenience, follow the product rules in this file and in docs/MVP_TASKS.md.

If a requirement is ambiguous:
- choose the more explainable and analyst-friendly implementation
- document the decision in code comments or docs where appropriate