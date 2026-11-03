-- Reverts V018.
REVOKE INSERT ON auth.idempotency_key FROM auth_writer;
REVOKE SELECT ON auth.idempotency_key FROM auth_reader;
