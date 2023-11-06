import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :message_queue, MessageQueueWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "WfpyGYRbgRYP5LgmdSkAX4leltIhH5qJfJIZI5A+PEOW8hduXfpiE6aZMHOYoyWT",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :message_queue, :manual_enqueue, true
config :message_queue, :rate_limit_interval_milliseconds, 1
