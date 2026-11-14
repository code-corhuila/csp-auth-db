-- One pending registration per email (issue csp-docs#282): a new request soft-deletes the previous pending one (deleted_at, as in V028) and
-- this index makes two concurrent requests for the same address fail instead of leaving two valid tokens. Only rows that hold a token can be
-- pending. Built CONCURRENTLY in its own migration (Annex A, rule 14).
CREATE UNIQUE INDEX CONCURRENTLY uk_registration_request_email_pending ON auth.registration_request (email) WHERE token_hash IS NOT NULL AND used_at IS NULL AND deleted_at IS NULL;
