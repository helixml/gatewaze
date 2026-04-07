# Requirements: Gatewaze Startup Script

## User Story

As a developer starting a new coding session, I want the gatewaze stack to boot automatically so I can begin working immediately without manual setup steps.

## Acceptance Criteria

- [ ] Script lives at `~/work/helix-specs/.helix/startup.sh`
- [ ] Script boots the full gatewaze stack (Supabase, Redis, Traefik, app services)
- [ ] First-time setup is handled automatically (`make init` if `docker/.env` doesn't exist)
- [ ] Script is idempotent — safe to run repeatedly without side effects
- [ ] Script runs non-interactively (no prompts)
- [ ] Script logs output to `/tmp/helix-startup.log` for debugging
- [ ] Script exits 0 on success, non-zero on failure
