-- Reverts V045.
REVOKE SELECT, INSERT, UPDATE, DELETE ON auth.registration_request FROM auth_reader, auth_writer;
