defmodule CodeForConduct.EventController do
  use Phoenix.Controller
  alias CodeForConduct.Event
  alias CodeForConduct.Repo

  plug :action

  def index(conn, _) do
    IO.puts "You here? are you? hello?"
    e = Repo.all(Event)
    json conn, ures(e)
  end

  def show(conn, %{"id" => id}) do
    IO.puts "Showing event #{id}"
    { iid, _ } = Integer.parse(id)
    case Repo.get(Event, iid) do
      nil ->
        json conn, %{"error" => "Event #{iid} does not exist."}
      event ->
        json conn, ure(Repo.get(Event, iid))
    end
  end

  defp ures([e|rest]) do
    [ure(e) | ures(rest)]
  end

  defp ures([]) do
    []
  end

  defp ure(e) do
    %{ :ebid => e.ebid, :id => e.id, :ownerid => e.ownerid }
  end
end
