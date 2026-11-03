-- Reverts V027.
DROP INDEX IF EXISTS auth.idx_email_verification_expires_at_complete;
