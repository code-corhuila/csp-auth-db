-- Contact fields captured at registration (ADR-024). Nullable so rows that predate them stay valid;
-- the register endpoint is what makes them mandatory for new accounts.
ALTER TABLE auth.app_user
    ADD COLUMN phone TEXT,
    ADD COLUMN address TEXT,
    ADD CONSTRAINT chk_app_user_phone_format CHECK (phone ~ '^\+?[0-9]{7,15}$'),
    ADD CONSTRAINT chk_app_user_address_length CHECK (char_length(address) BETWEEN 1 AND 255);
