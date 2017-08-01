use Mix.Config

config :inject_detect, InjectDetect.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "ec2-54-89-222-187.compute-1.amazonaws.com", port: 80],
  server: true,
  root: ".",
  version: Mix.Project.config[:version],
  cache_static_manifest: "priv/static/manifest.json"

config :logger, level: :debug

import_config "stage.secret.exs"
