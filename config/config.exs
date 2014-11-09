# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the router
config :phoenix, CodeForConduct.Router,
  url: [host: "localhost"],
  http: [port: System.get_env("PORT")],
  https: false,
  secret_key_base: "NIBZCfFqI2ug2X7kf28k2bqycK9WBZEZ5vxwjITmqyEiUlHxBXbodEPy0wiqBbgR3SEoRdDb263idwN/lyCAog==",
  catch_errors: true,
  debug_errors: false,
  error_controller: CodeForConduct.PageController

# Session configuration
config :phoenix, CodeForConduct.Router,
  session: [store: :cookie,
            key: "_code_for_conduct_key"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :code_for_conduct, CodeForConduct.PageController,
  client_id: [System.get_env("EVENTBRITE_ID")],
  client_secret: [System.get_env("EVENTBRITE_SECRET")]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

IO.puts "HOLY CRAP -- mix is #{Mix.env}"
