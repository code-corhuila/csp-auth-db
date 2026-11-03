-- Retention purge (ADR-030): first branch of "expires_at < cutoff OR revoked_at < cutoff". Partial: only revoked rows are
-- ever purged by this column. The table has data, so it is built CONCURRENTLY in its own migration (Annex A, rule 14).
CREATE INDEX CONCURRENTLY idx_refresh_token_revoked_at ON auth.refresh_token (revoked_at) WHERE revoked_at IS NOT NULL;
