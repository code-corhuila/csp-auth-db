-- Reverts V024.
ALTER TABLE auth.email_verification
    DROP CONSTRAINT IF EXISTS chk_email_verification_attempt_count_range,
    DROP CONSTRAINT IF EXISTS chk_email_verification_new_email_length,
    DROP COLUMN IF EXISTS attempt_count,
    DROP COLUMN IF EXISTS new_email;
