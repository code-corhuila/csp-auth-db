-- Reverts V039.
DROP INDEX IF EXISTS auth.idx_email_change_idempotency_key_created_at;
