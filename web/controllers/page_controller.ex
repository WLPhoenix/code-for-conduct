defmodule CodeForConduct.PageController do
  use Phoenix.Controller
  import HTTPoison
  import Poison
  import EventBrite

  alias CodeForConduct.Router

  plug :action

  def idx(conn, _) do
    render conn, "idx.html"
  end

  def index(conn, _params) do
    case get_session(fetch_session(conn), :eb_token) do
      nil ->
        redirect conn, to: CodeForConduct.Router.Helpers.page_path(:auth)
      token ->
        %{"name" => name, "emails" => emails} = EventBrite.get_user_info(token)
        render conn, "index.html", name: name, emails: emails, events: EventBrite.get_event_info(token)
    end
  end


  def build_body(code) do
    IO.puts "Building auth body for code: " <> code
        env = Application.get_env(:code_for_conduct, CodeForConduct.PageController)
                client_id = env[:client_id]
        client_secret = env[:client_secret]
                {:ok, "code=#{code}&grant_type=authorization_code&client_id=#{client_id}&client_secret=#{client_secret}"}
  end

  defp get_token(code) do
          {:ok, body} = build_body(code)

    case HTTPoison.post("https://www.eventbrite.com/oauth/token", body, [{<<"Content-Type">>, <<"application/x-www-form-urlencoded">>}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body, }} ->
        case Poison.decode body do
                                        {:ok, %{"access_token" => token}} ->
                                                token
                                        {:error, r} ->
                                                raise r
        end
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        raise "Got #{status_code} (#{body})..."
      {:error, %HTTPoison.Error{reason: reason}} ->
        raise reason
    end
  end

  def auth(conn, %{"code" => code}) do
    IO.puts "i got a code " <> code
    token = get_token(code)
    conn = put_session(fetch_session(conn), :eb_token, token)
    dest = CodeForConduct.Router.Helpers.page_path(:index)
    redirect conn, to: "/" # dest doesn't really seem to work right
  end

  def auth(conn, _params) do
    IO.puts "just tryin to auth man"
        env = Application.get_env(:code_for_conduct, CodeForConduct.PageController)
                client_id = env[:client_id]
    url = "https://www.eventbrite.com/oauth/authorize?response_type=code&client_id=#{client_id}"
    body = "<html><body>You are being <a href=\"#{Phoenix.HTML.html_escape(url)}\">redirected</a>.</body></html>"

    conn
    |> put_resp_header("Location", url)
    |> send_resp(302, "text/html", body)
  end

  defp send_resp(conn, default_status, content_type, body) do
    conn
    |> put_resp_content_type(content_type)
    |> send_resp(conn.status || default_status, body)
    |> halt()
  end

  def not_found(conn, _params) do
    render conn, "not_found.html"
  end

  def error(conn, _params) do
    render conn, "error.html"
  end
end
