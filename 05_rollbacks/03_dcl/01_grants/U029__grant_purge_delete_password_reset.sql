-- Reverts V029.
REVOKE DELETE ON auth.password_reset FROM auth_writer;
