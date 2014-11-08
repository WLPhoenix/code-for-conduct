defmodule CodeForConduct.PageController do
  use Phoenix.Controller
  import HTTPoison

  plug :action

  def index(conn, _params) do
    render conn, "index"
  end

  def auth(conn, %{"code" => code}) do
    IO.puts "i got a code " <> code
    case HTTPoison.get("http://google.com") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :-("
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.puts "I got a different code #{status_code} -- what the hell?"
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
