defmodule CodeForConduct.PageController do
  use Phoenix.Controller
  import HTTPoison

  plug :action

  def index(conn, _params) do
    render conn, "index"
  end

  def auth(conn, %{"code" => code}) do
    IO.puts "i got a code " <> code
    body = "code=#{code}&grant_type=authorization_code&client_secret=CDRPVW63YBXLHSPGL4Q25AFJKTXC7EYWOJ6LOQEE3UDIOABT6N&client_id=7EBFEB24BRVOV6J5KG"
#    case HTTPoison.post("http://localhost:9000", body, [{<<"Content-Type">>, <<"application/x-www-form-urlencoded">>}]) do
    case HTTPoison.post("https://www.eventbrite.com/oauth/token", body, [{<<"Content-Type">>, <<"application/x-www-form-urlencoded">>}]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts "BODY :: [[#{body}]]"
      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        IO.puts "Not found :-( #{body}"
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.puts "I got a different code #{status_code} -- what the hell? #{body}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
    render conn, "auth_test", code: code
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
