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
  secret_key_base: "S85DauV7FPE/+1e8YkrC7O2WCmAkY02JYdwKfSoxsp4dFqbbquy2dIl+idIVFHi9AxlXMTU7CYogkKpSdaeFTw=="

