-- Reverts V016.
ALTER TABLE auth.idempotency_key DROP CONSTRAINT IF EXISTS fk_idempotency_key_app_user;
