-- Append-only: csp-auth-api inserts and reads keys through auth_writer, which inherits auth_reader,
-- and never updates or deletes them (the MVP has no purge of keys).
GRANT SELECT ON auth.idempotency_key TO auth_reader;
GRANT INSERT ON auth.idempotency_key TO auth_writer;
