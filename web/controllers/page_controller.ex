defmodule CodeForConduct.PageController do
  use Phoenix.Controller
  import HTTPoison
  import Poison
  import EventBrite

  plug :action

  def index(conn, _params) do
    render conn, "index"
  end


  defp get_token(code) do
    body = "code=#{code}&grant_type=authorization_code&client_secret=CDRPVW63YBXLHSPGL4Q25AFJKTXC7EYWOJ6LOQEE3UDIOABT6N&client_id=7EBFEB24BRVOV6J5KG"
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
    %{"name" => name, "emails" => emails} = EventBrite.get_user_info(token)
    render conn, "auth_test", token: token, name: name, emails: emails
  end

  def auth(conn, _params) do
    IO.puts "just tryin to auth man"
    redirect conn, "https://www.eventbrite.com/oauth/authorize?response_type=code&client_id=7EBFEB24BRVOV6J5KG"
  end

  def not_found(conn, _params) do
    render conn, "not_found"
  end

  def error(conn, _params) do
    render conn, "error"
  end
end
