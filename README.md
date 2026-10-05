# csp-auth-db

> auth bounded context: database (schema, seeds, migrations)

Part of the **Cinesync Platform** distributed system — team `cinesync-platform`, Group 1.
Governance and documentation live in [`csp-docs`](https://github.com/code-corhuila/csp-docs).

## Purpose

This repository is the **only owner of the `auth` schema** of the Cinesync Platform: its structure, seed data,
roles and migrations. `csp-auth-api` consumes the schema and never versions it. A migration of auth
that lives anywhere else is a serious fault (Norma 5.2.1).

The repository currently holds the **base scaffold only**: the layout, the schema, its seven tables, the seed of the
roles `CLIENT` and `ADMIN`, the database roles and the rebuild verification. Functionality is added later, each change
with its own migration and reversion.

Tables (singular, schema `auth`): `app_user`, `role`, `user_role`, `refresh_token`, `email_verification`,
`password_reset` and `outbox_event`. `app_user` is not called `user` because that is a reserved word in PostgreSQL.

## Stack

| Item | Decision | Record |
|---|---|---|
| Engine | PostgreSQL 16, schema `auth` | [ADR-015](https://github.com/code-corhuila/csp-docs/blob/main/05-architecture/decisions/records/ADR-015-auth-go-postgresql-flyway.md) |
| Migration tool | Flyway, with `U` reversion scripts | [ADR-015](https://github.com/code-corhuila/csp-docs/blob/main/05-architecture/decisions/records/ADR-015-auth-go-postgresql-flyway.md) |
| Table names and columns | Singular, `app_user` for users | [ADR-023](https://github.com/code-corhuila/csp-docs/blob/main/05-architecture/decisions/records/ADR-023-auth-scaffold-decisions.md) |
| Outbox reader of the worker | Read-only role `auth_outbox_reader`, no `processed_at` | [ADR-019](https://github.com/code-corhuila/csp-docs/blob/main/05-architecture/decisions/records/ADR-019-outbox-relay-read-only-for-other-domains.md) |
| Policy | Migrations live only in each `-db` | [`migration-strategy.md`](https://github.com/code-corhuila/csp-docs/blob/main/06-data/migration-strategy.md) |

The single PostgreSQL instance and its volume are defined in `csp-infra-postgres` (Annex J). This repository defines
**no database service and no volume**: it provides only the migration executor.

## Related repositories

| Repository | Relation |
|---|---|
| `csp-auth-api` | Connects with the user `auth_app`; runs no migration |
| `csp-infra-postgres` | Defines the instance, creates the login users from secrets and composes the executor |
| `csp-worker` | Reads the auth outbox through the role `auth_outbox_reader` and never writes the schema |
| `csp-docs` | Governance, data model, contracts and ADRs |

## Layout

```
flyway.toml                  locations (the four families), naming validation, schema auth, clean disabled
01_ddl/ 02_dml/ 03_dcl/ 04_tcl/   migrations V<version>__<description>.sql, by family and sub-folder
05_rollbacks/                U<version>__<description>.sql: the reversion of every V<version>
deploy/compose.yml           the migration executor (no database service)
.github/workflows/db-ci.yml  rebuilds the schema from an empty database on every pull request
```

The order of the migrations is the version in the file name (`V001`, `V002`, ...): one sequence for the whole
repository, whatever the folder. A new migration takes the next number, and a migration that is already applied is
never edited (Flyway refuses it with a checksum error). The history lives in `auth.flyway_schema_history`.

## Run the executor

The instance belongs to `csp-infra-postgres`, which also composes this file. To run the executor alone, start that instance on the `platform` network and, from this repository:

```bash
cp .env.example .env     # and set the real values; never commit .env
docker compose -f deploy/compose.yml --env-file .env --profile tooling run --rm auth-db-migrate            # migrate
docker compose -f deploy/compose.yml --env-file .env --profile tooling run --rm auth-db-migrate validate   # checksums
```

## Reversion

Flyway Community does not undo, and `flyway undo` is not used here. The reversion of `V<n>` is the script
`U<n>` in `05_rollbacks/`, applied with `psql` **from the highest version down**. Before `U001`, the control table
`auth.flyway_schema_history` is dropped, because `U001` drops the schema. `db-ci.yml` runs exactly this order:
migrate, migrate again (nothing to apply), every `U` script descending, migrate. In production a correction is a new
forward migration.

## Branching

Three permanent branches. **None of them accepts a direct commit** — you enter through a child
branch and leave through a Pull Request.

```
develop  <--PR--  feat/... fix/... chore/...
qa       <--PR--  qa/...
main     <--PR--  release/...  hotfix/...
```

Promotion happens **by re-application** (`git cherry-pick -x`), never by merging one permanent
branch into another: `merge develop -> qa` and `merge qa -> main` do not exist in this model.

`main` requires **1 approval from `ariel5253`**. On `develop` and `qa` the team sets its own review
rule.

Full policy: `00-governance/branching-policy.md` in `csp-docs`.

## Pull Requests and commits

- Commits follow Conventional Commits: `<type>(<scope>): <description>`, in English, lowercase and imperative.
- A Pull Request has at most **400 changed lines** (additions plus deletions) and one logical goal.
- Every Pull Request targets the permanent branch that matches its prefix, according to the diagram above.
