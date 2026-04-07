# Implementation Tasks

- [x] Replace contents of `/home/retro/work/helix-specs/.helix/startup.sh` with the gatewaze boot script
- [x] Script should: check for docker and make, cd to gatewaze dir, run `make init` if needed, run `make up`
- [x] Ensure all output is logged to `/tmp/helix-startup.log`
- [x] Test the script runs cleanly on a fresh session
