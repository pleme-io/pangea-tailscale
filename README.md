# pangea-tailscale

Tailscale provider resources for the [Pangea][1] infrastructure DSL.

19 typed Terraform resources covering ACL, DNS, devices, OAuth clients,
federated identity, log streaming, posture integrations, tailnet keys,
settings, and webhooks.

```ruby
require 'pangea-tailscale'

class FleetTailnet < Pangea::Architecture
  include Pangea::Resources::Tailscale

  def synthesize
    tailscale_acl 'fleet-policy' do
      acl JSON.dump(
        grants: [{ src: ['tag:dev'], dst: ['tag:fleet:*'], ip: ['*'] }],
        ssh:    [{ action: 'accept', src: ['tag:dev'], dst: ['tag:fleet'], users: ['drzzln'] }]
      )
    end

    tailscale_tailnet_settings 'fleet' do
      acls_externally_managed_on true
      devices_approval_on        true
      devices_key_duration_days  90
      https_enabled              true
    end
  end
end
```

## Installation

```ruby
gem 'pangea-tailscale'
```

## Provider authentication

The Tailscale Terraform provider authenticates via OAuth client (preferred)
or API key:

```sh
# OAuth client (preferred)
export TAILSCALE_OAUTH_CLIENT_ID=$(cat ~/.config/tailscale/oauth-client-id)
export TAILSCALE_OAUTH_CLIENT_SECRET=$(cat ~/.config/tailscale/oauth-client-secret)

# API key (deprecated)
export TAILSCALE_API_KEY=tskey-api-…

# Tailnet selector ('-' = the default tailnet of the authenticated principal)
export TAILSCALE_TAILNET=-
```

These are SOPS-encrypted in the [pleme-io/nix][2] repo and rendered to
`~/.config/tailscale/oauth-client-{id,secret}` on every Mac dev workstation.

## Resources

| Resource | Purpose |
|---|---|
| `tailscale_acl` | Tailnet policy file (HuJSON or JSON) |
| `tailscale_aws_external_id` | Mint AWS External ID for log-streaming role assumption |
| `tailscale_contacts` | Account / support / security contact emails |
| `tailscale_device_authorization` | Approve a device into the tailnet |
| `tailscale_device_key` | Per-device key properties (expiry-disabled) |
| `tailscale_device_subnet_routes` | Enabled subnet routes per device |
| `tailscale_device_tags` | Tags applied to a device (drives ACL grants) |
| `tailscale_dns_configuration` | Whole-tailnet DNS (preferred) |
| `tailscale_dns_nameservers` | DNS nameservers (legacy) |
| `tailscale_dns_preferences` | MagicDNS toggle (legacy) |
| `tailscale_dns_search_paths` | DNS search domains (legacy) |
| `tailscale_dns_split_nameservers` | Per-domain split DNS (legacy) |
| `tailscale_federated_identity` | OIDC workload-identity federation |
| `tailscale_logstream_configuration` | Stream audit/network logs to a SIEM |
| `tailscale_oauth_client` | OAuth client for programmatic API access |
| `tailscale_posture_integration` | Device-posture data integration |
| `tailscale_tailnet_key` | Pre-authentication keys for new nodes |
| `tailscale_tailnet_settings` | Tailnet-wide settings (approval, key duration, HTTPS, …) |
| `tailscale_webhook` | Webhook endpoint for tailnet events |

## Source of truth

Resource attributes are defined in
[`tailscale-terraform-resources`][3] (TOML catalog). To regenerate:

```sh
ruby tools/regen.rb /path/to/tailscale-terraform-resources
```

Once `pangea-forge` is healed past the in-flight synthesizer-family
refactor, regen will move to:

```sh
iac-forge generate \
  --backend pangea \
  --resources ../tailscale-terraform-resources/resources \
  --provider ../tailscale-terraform-resources/provider.toml \
  --output ./
```

## Tests

```sh
bundle install
bundle exec rspec
```

[1]: https://github.com/pleme-io/pangea-core
[2]: https://github.com/pleme-io/nix
[3]: https://github.com/pleme-io/tailscale-terraform-resources
