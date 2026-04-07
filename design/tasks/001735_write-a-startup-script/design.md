# Design: Gatewaze Startup Script

## Overview

A simple bash script that delegates to the gatewaze project's existing `Makefile` targets. No wrapper frameworks or custom orchestration needed — the Makefile already handles env validation, Traefik startup, and Docker Compose orchestration.

## How Gatewaze Boots

The gatewaze project at `/home/retro/work/gatewaze/` uses:

1. **`make init`** — copies `docker/.env.example` → `docker/.env` (first-time only)
2. **`make up`** — starts everything:
   - Validates env file exists (`_check-env`)
   - Starts shared Traefik proxy (`_ensure-traefik`)
   - Generates MCP config (`_generate-mcp`)
   - Runs `docker compose up` with dev overrides (hot reload, volume mounts)

### Services Started

| Service | URL | Port |
|---------|-----|------|
| Admin Dashboard | http://gatewaze-admin.localhost | 5274 |
| Public Portal | http://gatewaze-app.localhost | 3100 |
| API Server | http://gatewaze-api.localhost | 3002 |
| Supabase Studio | http://gatewaze-studio.localhost | 54323 |
| PostgreSQL | — | 54322 |
| Redis | — | 6379 |
| Traefik Dashboard | — | 8080 |

## Script Design

```
startup.sh
├── Check prerequisites (docker, make)
├── cd to /home/retro/work/gatewaze
├── Run `make init` if docker/.env missing
├── Run `make up` (detached, non-interactive)
└── Log everything to /tmp/helix-startup.log
```

### Key Decisions

- **Delegate to Makefile** rather than reimplementing Docker Compose logic. The Makefile handles brand detection, Traefik networking, env validation, and compose file selection.
- **Run in background** — `make up` starts containers detached via Docker Compose's `-d` flag (already configured in the Makefile). The script itself runs synchronously but returns quickly.
- **No health checks in script** — Docker Compose healthchecks handle readiness. First DB startup takes ~2 minutes; subsequent starts are fast.

### Codebase Patterns Found

- The Makefile uses `COMPOSE_PROJECT_NAME` from `.env` to namespace containers
- `dev.sh` is an alternative entry point but `make` is the canonical interface
- Multi-brand support exists but is optional — default single-brand mode works out of the box

## Implementation Notes

- **Used `dev.sh` instead of `make`** — the agent environment doesn't have `make` installed, but `dev.sh` performs the same orchestration (env detection, Traefik startup, compose file selection, `docker compose up -d --build`). This makes the script work in more environments.
- **Replaced `make init` with direct `cp`** — `make init` just copies `docker/.env.example` to `docker/.env`. Since we're not using make, we do the copy directly.
- **`exec > >(tee -a "$LOG") 2>&1`** — redirects all stdout+stderr to both the terminal and the log file. Uses append mode so repeated runs don't overwrite previous logs.
- **Tested successfully** — all 16 containers start: admin, portal, api, worker, scheduler, redis, traefik, and 9 supabase services (db, auth, rest, realtime, storage, kong, edge-functions, meta, studio).
- **First run pulls ~20+ Docker images** and takes several minutes. Subsequent runs are fast (~10s).
