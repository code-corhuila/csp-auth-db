-- Reverts V019.
REVOKE DELETE ON auth.refresh_token, auth.idempotency_key FROM auth_writer;
