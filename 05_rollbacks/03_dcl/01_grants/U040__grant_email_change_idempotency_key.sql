-- Reverts V040.
REVOKE INSERT, DELETE ON auth.email_change_idempotency_key FROM auth_writer;
REVOKE SELECT ON auth.email_change_idempotency_key FROM auth_reader;
