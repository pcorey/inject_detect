use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :inject_detect, InjectDetect.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :inject_detect, InjectDetect.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "inject_detect_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :inject_detect, InjectDetect.Mailer,
  adapter: Bamboo.LocalAdapter,
  username: "username",
  password: "password"

config :inject_detect,
  stripe_module: Stripe.Mock
