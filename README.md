# Material8

Material8 is an analyst-focused dashboard for SEC Form 8-K filings. The MVP prioritizes fast scanning of high-signal non-earnings events and rule-first, explainable classification.

## Milestone status

### ✅ Milestone 1 complete
- Repository scaffold for backend and frontend
- Docker Compose local development stack
- Postgres + Redis infrastructure
- Initial schema migrations for required MVP tables
- Backend and frontend smoke test harnesses

### 🚧 Stubbed for later milestones
- SEC ingestion jobs and EDGAR client
- Exclusion/topic/importance engines
- Feed/detail API endpoints beyond health checks
- Dashboard feed UI, filters, pagination, and admin workflows

## Repository layout

```text
.
├── backend/
│   ├── app/
│   ├── migrations/sql/
│   ├── scripts/
│   └── tests/
├── frontend/
│   ├── src/app/
│   └── tests/
├── docs/
│   └── MVP_TASKS.md
└── docker-compose.yml
```

## Prerequisites

- Docker + Docker Compose
- (Optional local runtime) Python 3.11+
- (Optional local runtime) Node 20+

## Quick start (Docker)

1. Start services:
   ```bash
   docker compose up --build -d
   ```
2. Run database migrations:
   ```bash
   docker compose exec backend python scripts/migrate.py
   ```
3. Verify app health:
   ```bash
   curl http://localhost:8000/healthz
   curl http://localhost:3000
   ```

## Local development (without Docker)

### Backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -e .[dev]
cp .env.example .env
uvicorn app.main:app --reload
```

Run migrations:
```bash
python scripts/migrate.py
```

Run tests:
```bash
pytest
```

### Frontend

```bash
cd frontend
npm install
cp .env.example .env.local
npm run dev
```

Run tests:
```bash
npm test
```

## Environment variables

### Backend (`backend/.env`)
- `APP_NAME`
- `APP_ENV`
- `APP_PORT`
- `POSTGRES_HOST`
- `POSTGRES_PORT`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `REDIS_URL`

### Frontend (`frontend/.env.local`)
- `NEXT_PUBLIC_API_BASE_URL`

## Initial database schema

Migration `backend/migrations/sql/0001_init.sql` creates required MVP tables:
- `companies`
- `filings`
- `filing_events`
- `admin_overrides`
- `ingestion_runs`

It also creates `schema_migrations` and baseline indexes.

## Commands to run this milestone

```bash
docker compose up --build -d
docker compose exec backend python scripts/migrate.py
docker compose exec backend pytest
docker compose exec frontend npm test
```
