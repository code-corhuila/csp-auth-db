-- Hashed single-use tokens of the password recovery flow. The raw token is never stored.
CREATE TABLE auth.password_reset (
    id         uuid        NOT NULL DEFAULT gen_random_uuid(),
    user_id    uuid        NOT NULL,
    token_hash text        NOT NULL,
    expires_at timestamptz NOT NULL,
    used_at    timestamptz,
    created_at timestamptz NOT NULL DEFAULT NOW(),
    updated_at timestamptz NOT NULL DEFAULT NOW(),
    deleted_at timestamptz,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT pk_password_reset PRIMARY KEY (id),
    CONSTRAINT uk_password_reset_token_hash UNIQUE (token_hash),
    CONSTRAINT chk_password_reset_token_hash_length CHECK (char_length(token_hash) BETWEEN 1 AND 255)
);
