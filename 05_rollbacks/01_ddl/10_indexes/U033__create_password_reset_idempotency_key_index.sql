-- Reverts V033.
DROP INDEX IF EXISTS auth.idx_password_reset_idempotency_key_password_reset_id;
