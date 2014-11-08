defmodule CodeForConduct.PageController do
  use Phoenix.Controller
  import HTTPoison
  import Poison
  import EventBrite

  alias CodeForConduct.Router

  plug :action

  def index(conn, _params) do
    case get_session(conn, :eb_token) do
      nil ->
        redirect conn, CodeForConduct.Router.Helpers.pages_path(:auth)
      token ->
        %{"name" => name, "emails" => emails} = EventBrite.get_user_info(token)
        render conn, "index", name: name, emails: emails
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
    conn = put_session(conn, :eb_token, token)
    dest = CodeForConduct.Router.Helpers.pages_path(:index)
    redirect conn, "/" # dest doesn't really seem to work right
  end

  def auth(conn, _params) do
    IO.puts "just tryin to auth man"
  	env = Application.get_env(:code_for_conduct, CodeForConduct.PageController)
		client_id = env[:client_id]
    redirect conn, "https://www.eventbrite.com/oauth/authorize?response_type=code&client_id=#{client_id}"
  end

  def not_found(conn, _params) do
    render conn, "not_found"
  end

  def error(conn, _params) do
    render conn, "error"
  end
end
