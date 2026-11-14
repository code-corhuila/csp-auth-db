-- Limit of registration requests per email in a rolling hour (issue csp-docs#282): counts the rows of one address by created_at, those that
-- created nothing included. Built CONCURRENTLY in its own migration (Annex A, rule 14).
CREATE INDEX CONCURRENTLY idx_registration_request_email_created_at ON auth.registration_request (email, created_at);
