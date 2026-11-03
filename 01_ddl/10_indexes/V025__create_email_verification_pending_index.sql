-- One active email-change request per user (ADR-034): a new request soft-deletes the previous pending one, and this index makes
-- two concurrent requests of the same user fail instead of leaving two valid codes. Built CONCURRENTLY in its own migration (Annex A, rule 14).
CREATE UNIQUE INDEX CONCURRENTLY uk_email_verification_user_id_pending ON auth.email_verification (user_id) WHERE verified_at IS NULL AND deleted_at IS NULL;
