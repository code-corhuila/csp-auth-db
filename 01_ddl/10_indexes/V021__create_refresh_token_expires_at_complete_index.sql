-- Retention purge (ADR-030): second branch of the OR. idx_refresh_token_expires_at (V010) is partial on revoked_at IS NULL, so
-- it cannot serve a revoked row that also expired; this complete index can, and lets the planner combine both branches.
CREATE INDEX CONCURRENTLY idx_refresh_token_expires_at_complete ON auth.refresh_token (expires_at);
