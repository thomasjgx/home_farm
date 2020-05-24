# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :home_farm,
  ecto_repos: [HomeFarm.Repo]

# Configures the endpoint
config :home_farm, HomeFarmWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jDG21PW953109QAP/QJo9krBde/bormke/eSfuSXn+ff8D4EKiVAU2wEdLiAokEr",
  render_errors: [view: HomeFarmWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HomeFarm.PubSub,
  live_view: [signing_salt: "nRUl9opV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
