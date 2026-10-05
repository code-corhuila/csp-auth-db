-- Reverts V014.
ALTER TABLE auth.app_user
    DROP CONSTRAINT IF EXISTS chk_app_user_address_length,
    DROP CONSTRAINT IF EXISTS chk_app_user_phone_format,
    DROP COLUMN IF EXISTS address,
    DROP COLUMN IF EXISTS phone;
