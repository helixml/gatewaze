# Add gatewaze startup script

## Summary
Replaces the placeholder startup script with one that boots the full gatewaze stack (Supabase, Redis, Traefik, and all app services) using `dev.sh`.

## Changes
- Rewrote `.helix/startup.sh` to check prerequisites, initialize `docker/.env` on first run, and start the stack via `dev.sh up`
- All output logged to `/tmp/helix-startup.log`

## Testing
Ran the script in a fresh environment. All 16 containers started successfully (admin, portal, api, worker, scheduler, redis, traefik, and 9 supabase services).
