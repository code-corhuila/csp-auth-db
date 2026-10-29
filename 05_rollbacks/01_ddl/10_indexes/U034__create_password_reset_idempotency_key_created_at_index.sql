-- Reverts V034.
DROP INDEX IF EXISTS auth.idx_password_reset_idempotency_key_created_at;
