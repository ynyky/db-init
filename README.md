# db-init

Postgres init container: creates database roles/databases and raises
`vm.max_map_count` before the main Postgres container starts.

## Scripts

- `bin/db_setup` — creates or updates the DB roles listed in `DB_ROLE_NAMES`
  and the target database. Does nothing (and exits 0) if `DB_MASTER_PASS`
  is not set.
- `bin/memory_max_map_count_setup` — raises `vm.max_map_count` to `524288`
  if it's currently lower. Requires the init container to run with enough
  privilege to call `sysctl -w` (e.g. a privileged `securityContext`).

## Requirements

Environment variables — see [envs.yaml](envs.yaml) for the full list and
defaults:

- `DB_MASTER_USER`, `DB_MASTER_PASS`
- `DB_ROLE_NAMES` (and the matching `DB_<ROLE>_NAME` / `DB_<ROLE>_PASS` /
  `DB_<ROLE>_ROLES` variables)
- `DB_OWNER`, `DB_LOCALE`, `DB_TEMPLATE`, `DB_NAME`, `DB_PORT`
- `TEST` — set to `true` to print the SQL instead of running it

## CI

`.github/workflows/build.yml` lints the scripts in `bin/` with ShellCheck,
then builds and pushes the image to Docker Hub as
`${DOCKERHUB_USER}/db-init:<date>-<commit-sha>` (and `:latest`) on every
push to `main`. Requires the `DOCKERHUB_USER` and `DOCKERHUB_TOKEN`
repository secrets, same as `infra-registry-creds`.
