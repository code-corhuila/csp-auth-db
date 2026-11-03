-- Reverts V022.
DROP INDEX IF EXISTS auth.idx_idempotency_key_created_at;
