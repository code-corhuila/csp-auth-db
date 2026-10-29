-- Retention purge (ADR-030): rows older than 7 days, oldest first. Built CONCURRENTLY in its own migration (Annex A, rule 14).
CREATE INDEX CONCURRENTLY idx_password_reset_idempotency_key_created_at ON auth.password_reset_idempotency_key (created_at);
