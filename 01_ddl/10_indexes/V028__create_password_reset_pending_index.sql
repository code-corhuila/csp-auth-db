-- One active password reset per user (HU-AUTH-006): a new request soft-deletes the previous pending one (deleted_at, the same
-- mechanism as the email change, V025), and this index makes two concurrent requests of the same user fail instead of leaving two
-- valid tokens. Expiry is not in the predicate: an expired row is dealt with by the API and the purge. Built CONCURRENTLY in its own
-- migration (Annex A, rule 14).
CREATE UNIQUE INDEX CONCURRENTLY uk_password_reset_user_id_pending ON auth.password_reset (user_id) WHERE used_at IS NULL AND deleted_at IS NULL;
