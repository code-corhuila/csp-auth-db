-- Short-lived one-time codes for email verification and email change.
CREATE TABLE auth.email_verification (
    id                uuid        NOT NULL DEFAULT gen_random_uuid(),
    user_id           uuid        NOT NULL,
    verification_code text        NOT NULL,
    expires_at        timestamptz NOT NULL,
    verified_at       timestamptz,
    created_at        timestamptz NOT NULL DEFAULT NOW(),
    updated_at        timestamptz NOT NULL DEFAULT NOW(),
    deleted_at        timestamptz,
    created_by        uuid,
    updated_by        uuid,
    CONSTRAINT pk_email_verification PRIMARY KEY (id),
    CONSTRAINT chk_email_verification_code_length CHECK (char_length(verification_code) = 6)
);
