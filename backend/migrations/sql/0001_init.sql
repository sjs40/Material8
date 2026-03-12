CREATE TABLE IF NOT EXISTS schema_migrations (
  version TEXT PRIMARY KEY,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS companies (
  id BIGSERIAL PRIMARY KEY,
  cik VARCHAR(10) NOT NULL UNIQUE,
  ticker VARCHAR(16),
  company_name TEXT NOT NULL,
  sector TEXT,
  industry TEXT,
  market_cap_bucket TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS filings (
  id BIGSERIAL PRIMARY KEY,
  accession_number TEXT NOT NULL UNIQUE,
  company_id BIGINT NOT NULL REFERENCES companies(id),
  form_type VARCHAR(16) NOT NULL,
  filed_at TIMESTAMPTZ NOT NULL,
  sec_filing_url TEXT NOT NULL,
  primary_document_url TEXT,
  item_numbers TEXT[] NOT NULL DEFAULT '{}',
  exhibit_numbers TEXT[] NOT NULL DEFAULT '{}',
  is_earnings_excluded BOOLEAN,
  exclusion_reason_codes TEXT[] NOT NULL DEFAULT '{}',
  raw_text TEXT,
  cleaned_text TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS filing_events (
  id BIGSERIAL PRIMARY KEY,
  filing_id BIGINT NOT NULL REFERENCES filings(id) ON DELETE CASCADE,
  primary_topic TEXT NOT NULL,
  secondary_tags TEXT[] NOT NULL DEFAULT '{}',
  importance TEXT NOT NULL,
  topic_reason_codes TEXT[] NOT NULL DEFAULT '{}',
  importance_reason_codes TEXT[] NOT NULL DEFAULT '{}',
  summary_short TEXT,
  summary_long TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS admin_overrides (
  id BIGSERIAL PRIMARY KEY,
  filing_id BIGINT NOT NULL REFERENCES filings(id) ON DELETE CASCADE,
  override_include BOOLEAN,
  override_topic TEXT,
  override_importance TEXT,
  note TEXT,
  created_by TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ingestion_runs (
  id BIGSERIAL PRIMARY KEY,
  source TEXT NOT NULL DEFAULT 'sec-edgar',
  status TEXT NOT NULL,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  finished_at TIMESTAMPTZ,
  filings_seen INT NOT NULL DEFAULT 0,
  filings_inserted INT NOT NULL DEFAULT 0,
  filings_updated INT NOT NULL DEFAULT 0,
  error_count INT NOT NULL DEFAULT 0,
  error_message TEXT,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS idx_filings_filed_at ON filings (filed_at DESC);
CREATE INDEX IF NOT EXISTS idx_filings_company_id ON filings (company_id);
CREATE INDEX IF NOT EXISTS idx_filing_events_filing_id ON filing_events (filing_id);
CREATE INDEX IF NOT EXISTS idx_ingestion_runs_started_at ON ingestion_runs (started_at DESC);
