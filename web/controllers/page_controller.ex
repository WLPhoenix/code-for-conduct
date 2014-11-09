defmodule CodeForConduct.PageController do
  use Phoenix.Controller

  plug :action

  def index(conn, _params) do
    case get_session(fetch_session(conn), :eb_token) do
      nil ->
        conn = put_session(conn, :eb_token, "WOOHOO")
        render conn, "index.html", tag: "NOT YET"
      token ->
        render conn, "index.html", tag: token
    end 
  end

  def not_found(conn, _params) do
    render conn, "not_found.html"
  end

  def error(conn, _params) do
    render conn, "error.html"
  end
end
