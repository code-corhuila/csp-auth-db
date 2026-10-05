-- Hashed refresh tokens issued at login, rotated and revoked. The raw token is never stored.
CREATE TABLE auth.refresh_token (
    id         uuid        NOT NULL DEFAULT gen_random_uuid(),
    user_id    uuid        NOT NULL,
    token_hash text        NOT NULL,
    expires_at timestamptz NOT NULL,
    revoked_at timestamptz,
    user_agent text,
    created_at timestamptz NOT NULL DEFAULT NOW(),
    updated_at timestamptz NOT NULL DEFAULT NOW(),
    deleted_at timestamptz,
    created_by uuid,
    updated_by uuid,
    CONSTRAINT pk_refresh_token PRIMARY KEY (id),
    CONSTRAINT uk_refresh_token_token_hash UNIQUE (token_hash),
    CONSTRAINT chk_refresh_token_token_hash_length CHECK (char_length(token_hash) BETWEEN 1 AND 255)
);
