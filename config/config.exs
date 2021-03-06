# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :notifications, Notifications.Web.Endpoint,
  url: [host: {:system, "NOTIFICATIONS_HOSTNAME", "example.com"}],
  http: [
    port: {:system, :integer, "NOTIFICATIONS_PORT", 4000},
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: {:system, "NOTIFICATIONS_SECRET_KEY_BASE"},
  render_errors: [view: Notifications.Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Notifications.PubSub,
  live_view: [signing_salt: "dSfR0RdO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :job_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  methods: ["GET", "POST"]

config :notifications, Notifications.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: {:system, "NOTIFICATIONS_SENDGRID_API_KEY"}

config :notifications,
  access_token: {:system, "NOTIFICATIONS_ACCESS_TOKEN"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
