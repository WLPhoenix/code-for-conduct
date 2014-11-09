defmodule CodeForConduct.EventController do
  use Phoenix.Controller
  alias CodeForConduct.Event
  alias CodeForConduct.Repo

  plug :action

  def index(conn, _) do
    IO.puts "You here? are you? hello?"
    e = Repo.all(Event)
    json conn, e
  end

  def show(conn, %{"id" => id}) do
    IO.puts "Showing event #{id}"
    { iid, _ } = Integer.parse(id)
    json conn, Repo.get(Event, iid)
  end
end
