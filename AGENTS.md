# pangea-tailscale — Agent Orientation

Auto-generated Pangea Ruby DSL for Tailscale. See `CLAUDE.md` for the full
orientation, regen path, and architecture.

## Quick rules

1. **Never hand-edit `lib/pangea/`** — those files are regenerated. Edit
   the TOML in `pleme-io/tailscale-terraform-resources` and run regen.
2. **Spec failures** → check the catalog TOML's required/optional/computed
   markers; the regen script derives `map`/`map_present`/`outputs` from them.
3. **New resource** → add a TOML to the catalog, regen, the gem picks it
   up automatically.

## Commands

```sh
ruby tools/regen.rb /path/to/tailscale-terraform-resources
bundle install
bundle exec rspec
```
