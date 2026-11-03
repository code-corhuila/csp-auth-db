-- Reverts V038.
DROP INDEX IF EXISTS auth.idx_email_change_idempotency_key_email_verification_id;
