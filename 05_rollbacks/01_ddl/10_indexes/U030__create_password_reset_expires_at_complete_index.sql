-- Reverts V030.
DROP INDEX IF EXISTS auth.idx_password_reset_expires_at_complete;
