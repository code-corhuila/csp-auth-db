-- Retention purge (ADR-030): rows older than 7 days, oldest first. Built CONCURRENTLY in its own migration (Annex A, rule 14).
CREATE INDEX CONCURRENTLY idx_registration_request_created_at ON auth.registration_request (created_at);
