-- Identity of an account. The name is app_user because user is a reserved word (ADR-023).
-- Failed-login counters and temporary locks live in Redis, not here.
CREATE TABLE auth.app_user (
    id             uuid        NOT NULL DEFAULT gen_random_uuid(),
    email          text        NOT NULL,
    name           text        NOT NULL,
    password_hash  text        NOT NULL,
    status         text        NOT NULL DEFAULT 'ACTIVE',
    email_verified boolean     NOT NULL DEFAULT FALSE,
    created_at     timestamptz NOT NULL DEFAULT NOW(),
    updated_at     timestamptz NOT NULL DEFAULT NOW(),
    deleted_at     timestamptz,
    created_by     uuid,
    updated_by     uuid,
    CONSTRAINT pk_app_user PRIMARY KEY (id),
    CONSTRAINT chk_app_user_status CHECK (status IN ('ACTIVE', 'LOCKED')),
    CONSTRAINT chk_app_user_email_length CHECK (char_length(email) BETWEEN 1 AND 255),
    CONSTRAINT chk_app_user_name_length CHECK (char_length(name) BETWEEN 1 AND 100),
    CONSTRAINT chk_app_user_password_hash_length CHECK (char_length(password_hash) BETWEEN 1 AND 255)
);
