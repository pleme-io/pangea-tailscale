# frozen_string_literal: true

require 'dry-types'
require 'pangea/resources/types'

module Pangea
  module Resources
    module Tailscale
      # Provider-specific Dry::Types for Tailscale resources.
      # Per-resource types.rb files reference these via
      # `T = Pangea::Resources::Tailscale::Types`.
      module Types
        include Dry.Types()

        T = ::Pangea::Resources::Types

        # Logstream destination types
        LogstreamDestinationType = T::String.constrained(
          included_in: %w[axiom cribl datadog elastic gcs panther splunk s3]
        )

        # Logstream log types
        LogstreamLogType = T::String.constrained(
          included_in: %w[configuration network]
        )

        # Logstream compression formats
        LogstreamCompressionFormat = T::String.constrained(
          included_in: %w[none zstd gzip]
        )

        # S3 authentication types
        S3AuthenticationType = T::String.constrained(
          included_in: %w[rolearn accesskey]
        )

        # Posture provider types
        PostureProvider = T::String.constrained(
          included_in: %w[falcon fleet huntress intune jamfpro kandji kolide sentinelone]
        )

        # Webhook provider types
        WebhookProviderType = T::String.constrained(
          included_in: %w[slack mattermost googlechat discord]
        )

        # Tailnet-key recreate-if-invalid policy
        TailnetKeyRecreatePolicy = T::String.constrained(
          included_in: %w[always never]
        )
      end
    end
  end
end
