-- GET /users (HU-AUTH-003): active accounts whose email starts with a prefix, LIKE 'prefix%' ESCAPE '\'. uk_app_user_email (V010) uses the
-- database collation, which a LIKE prefix cannot use outside the C collation; text_pattern_ops can. Partial like uk_app_user_email.
-- Built CONCURRENTLY in its own migration (Annex A, rule 14).
CREATE INDEX CONCURRENTLY idx_app_user_email_pattern ON auth.app_user (email text_pattern_ops) WHERE deleted_at IS NULL;
