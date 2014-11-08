use Mix.Config

# ## SSL Support
#
# To get SSL working, you will need to set:
#
#     https: [port: 443,
#             keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#             certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables point to a file on
# disk for the key and cert.

config :phoenix, CodeForConduct.Router,
  url: [host: "example.com"],
  http: [port: System.get_env("PORT")],
  secret_key_base: "NIBZCfFqI2ug2X7kf28k2bqycK9WBZEZ5vxwjITmqyEiUlHxBXbodEPy0wiqBbgR3SEoRdDb263idwN/lyCAog=="

config :logger, :console,
  level: :info

config :phoenix, :code_reloader, false
