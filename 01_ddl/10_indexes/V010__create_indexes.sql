-- The tables are empty when this migration first runs, so the indexes are created inside the
-- transaction. Later indexes on tables with data are CONCURRENTLY, in their own migration (rule 14).

-- Login email, unique among active accounts.
CREATE UNIQUE INDEX uk_app_user_email ON auth.app_user (email) WHERE deleted_at IS NULL;
-- Reads of active accounts.
CREATE INDEX idx_app_user_deleted_at ON auth.app_user (deleted_at) WHERE deleted_at IS NULL;

-- Foreign key columns. The user_id indexes are complete, not partial: the cascade from app_user
-- must also find the revoked, verified and used rows (Annex A, rule 3).
CREATE INDEX idx_user_role_user_id ON auth.user_role (user_id);
CREATE INDEX idx_user_role_role_id ON auth.user_role (role_id);
CREATE INDEX idx_refresh_token_user_id ON auth.refresh_token (user_id);
CREATE INDEX idx_email_verification_user_id ON auth.email_verification (user_id);
CREATE INDEX idx_password_reset_user_id ON auth.password_reset (user_id);

-- Expiry sweeps: only the rows still redeemable.
CREATE INDEX idx_refresh_token_expires_at ON auth.refresh_token (expires_at) WHERE revoked_at IS NULL;
CREATE INDEX idx_email_verification_expires_at ON auth.email_verification (expires_at) WHERE verified_at IS NULL;
CREATE INDEX idx_password_reset_expires_at ON auth.password_reset (expires_at) WHERE used_at IS NULL;

-- csp-worker reads the outbox in publication order.
CREATE INDEX idx_outbox_event_created_at ON auth.outbox_event (created_at, id);
