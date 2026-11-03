-- Retention purge of password reset tokens (HU-AUTH-006): rows whose expires_at is more than 7 days old, used or not.
-- idx_password_reset_expires_at (V010) is partial on used_at IS NULL, so it cannot serve a used row; this complete index can, and
-- lets the purge find the oldest rows without scanning the table. Built CONCURRENTLY in its own migration (Annex A, rule 14).
CREATE INDEX CONCURRENTLY idx_password_reset_expires_at_complete ON auth.password_reset (expires_at);
