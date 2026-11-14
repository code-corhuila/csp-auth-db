-- Reverts V035.
REVOKE INSERT, DELETE ON auth.password_reset_idempotency_key FROM auth_writer;
REVOKE SELECT ON auth.password_reset_idempotency_key FROM auth_reader;
