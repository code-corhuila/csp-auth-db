-- Reverts V026.
REVOKE DELETE ON auth.email_verification FROM auth_writer;
