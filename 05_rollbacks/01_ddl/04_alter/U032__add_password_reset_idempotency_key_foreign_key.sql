-- Reverts V032.
ALTER TABLE auth.password_reset_idempotency_key DROP CONSTRAINT IF EXISTS fk_password_reset_idempotency_key_password_reset;
