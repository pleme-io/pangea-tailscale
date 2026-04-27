# pangea-tailscale — Claude Orientation

> **★★★ CSE / Knowable Construction.** This repo operates under **Constructive Substrate Engineering** — canonical specification at [`pleme-io/theory/CONSTRUCTIVE-SUBSTRATE-ENGINEERING.md`](https://github.com/pleme-io/theory/blob/main/CONSTRUCTIVE-SUBSTRATE-ENGINEERING.md). The Compounding Directive (operational rules: solve once, load-bearing fixes only, idiom-first, models stay current, direction beats velocity) is in the org-level pleme-io/CLAUDE.md ★★★ section. Read both before non-trivial changes.


Auto-generated Pangea Ruby DSL for the Tailscale Terraform provider. 19
resources covering tailnet ACL, DNS, devices, OAuth clients, federated
identity, log streaming, posture, keys, settings, and webhooks.

## Reading order

1. `README.md` — usage + provider auth
2. `lib/pangea-tailscale.rb` — top-level requires (one require per resource)
3. `lib/pangea/resources/<resource>/{types,resource}.rb` — generated per
   resource (each pair = Dry::Struct attributes + ResourceBuilder DSL)
4. `lib/pangea/types/tailscale_types.rb` — provider-wide enum types
5. `tools/regen.rb` — bootstrap regenerator (TOML catalog → these files)

## Source of truth

The TOML catalog at `pleme-io/tailscale-terraform-resources` is the source
of truth. Every file under `lib/pangea/resources/` is regenerated from
that catalog — DO NOT hand-edit. To change behaviour, edit the TOML in
the catalog and re-run regen.

## Regen path

Two paths today:

1. **Bootstrap (current)**: `ruby tools/regen.rb /path/to/tailscale-terraform-resources`
2. **Canonical (target)**: once `pangea-forge` heals past the in-flight
   synthesizer-family refactor:

   ```sh
   iac-forge generate \
     --backend pangea \
     --resources ../tailscale-terraform-resources/resources \
     --provider ../tailscale-terraform-resources/provider.toml \
     --output ./
   ```

The bootstrap regen mirrors what pangea-forge would emit (matches the
shape established by `pangea-datadog` and `pangea-akeyless`). When
canonical regen lands, run both side-by-side, diff the trees, and only
delete `tools/regen.rb` once the diff is structural-only (formatting).

## Architecture

```
tailscale-terraform-resources (TOML catalog)
  └── resources/<category>/<resource>.toml   ← edit here

      ↓ tools/regen.rb (bootstrap) | iac-forge --backend pangea (canonical)

pangea-tailscale (this repo)
  ├── lib/pangea-tailscale.rb                ← top-level entry
  ├── lib/pangea-tailscale/version.rb
  ├── lib/pangea/types/tailscale_types.rb    ← enum constraints
  └── lib/pangea/resources/
      ├── tailscale.rb                       ← module aggregator
      └── <resource>/
          ├── types.rb                       ← Dry::Struct
          └── resource.rb                    ← define_resource DSL
```

## Tests

`spec/resources/<resource>_spec.rb` — one synthesis test per resource,
asserting:

1. `synth.<resource>('test', required_attrs)` produces valid Terraform JSON
2. The return value is a `Pangea::Resources::ResourceReference` with
   `resource_type == :<resource>`

Run with `bundle exec rspec` (needs sibling `pangea-core` checkout).

## Provider authentication

The Tailscale Terraform provider takes `oauth_client_id` + `oauth_client_secret`
(preferred) or `api_key` (deprecated). Wired through SOPS in `pleme-io/nix`
and rendered to `~/.config/tailscale/oauth-client-{id,secret}`.
