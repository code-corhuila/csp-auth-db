-- Complete (not partial): it is the index of the foreign key, so ON DELETE SET NULL from email_verification finds the rows (Annex A, rule 3).
-- The table is empty here, so it is created in the transaction.
CREATE INDEX idx_email_change_idempotency_key_email_verification_id ON auth.email_change_idempotency_key (email_verification_id);
