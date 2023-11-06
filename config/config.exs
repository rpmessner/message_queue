# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :message_queue,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :message_queue, MessageQueueWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: MessageQueueWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: MessageQueue.PubSub,
  live_view: [signing_salt: "E10YGtgm"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :message_queue, :rate_limit_interval_milliseconds, 1000
config :message_queue, :automatically_enqueue, true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
