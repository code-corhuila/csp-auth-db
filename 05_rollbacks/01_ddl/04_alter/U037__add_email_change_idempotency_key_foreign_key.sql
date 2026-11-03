-- Reverts V037.
ALTER TABLE auth.email_change_idempotency_key DROP CONSTRAINT IF EXISTS fk_email_change_idempotency_key_email_verification;
