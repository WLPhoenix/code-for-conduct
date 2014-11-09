defmodule CodeForConduct.EventController do
  use Phoenix.Controller
  alias CodeForConduct.Event
  alias CodeForConduct.Repo
  alias Poison, as: JSON

  def init(conn) do
    IO.puts "I init! #{conn}"
  end

  def index(conn, _) do
    IO.puts "You here? are you? hello?"
    e = Repo.all(Event)
    IO.puts "WE Got some events? #{e}"
    json conn, JSON.encode(e)
  end

  def show() do
    IO.puts "i hates you"
  end

  def show(conn) do
    IO.puts "got 1"
    json conn, "{}"
  end

  def show(conn, %{"id" => id}) do
    IO.puts "Showing event #{id}"
    json conn, JSON.encode(Repo.get(Event, id))
  end

  def show(_, _, _) do
    IO.puts("hi")
  end
  def show(_, _, _, _) do
    IO.puts("hi")
  end
  def show(_, _, _, _, _) do
    IO.puts("hi")
  end
end
