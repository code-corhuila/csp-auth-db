-- Retention purge (ADR-030, ADR-034): rows whose expires_at is more than 7 days old, verified or not. idx_email_verification_expires_at
-- (V010) is partial on verified_at IS NULL, so it cannot serve a verified row; this complete index can, and lets the purge find
-- the oldest rows without scanning the table. Built CONCURRENTLY in its own migration (Annex A, rule 14).
CREATE INDEX CONCURRENTLY idx_email_verification_expires_at_complete ON auth.email_verification (expires_at);
