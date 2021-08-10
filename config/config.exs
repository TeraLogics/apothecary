# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :apothecary,
  namespace: Apothecary

# Configures the endpoint
config :apothecary, ApothecaryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Psi7TwiB7uZ5tZ3uIpKPRadMYJcUf5IyMB3ys2v7ewH1604Gvi3Gfw2/g+EeaLV0",
  render_errors: [view: ApothecaryWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Apothecary.PubSub,
  live_view: [signing_salt: "wixRUkHU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
