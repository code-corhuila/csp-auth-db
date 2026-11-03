-- Email change (HU-AUTH-004, ADR-034). new_email is the address being verified; attempt_count counts the wrong codes of the
-- request (at 5 the API invalidates it). No code writes to the table before this story, so the NOT NULL column needs no default.
ALTER TABLE auth.email_verification
    ADD COLUMN new_email TEXT NOT NULL,
    ADD COLUMN attempt_count SMALLINT NOT NULL DEFAULT 0,
    ADD CONSTRAINT chk_email_verification_new_email_length CHECK (char_length(new_email) BETWEEN 3 AND 255),
    ADD CONSTRAINT chk_email_verification_attempt_count_range CHECK (attempt_count BETWEEN 0 AND 5);
