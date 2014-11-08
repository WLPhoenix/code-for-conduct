defmodule CodeForConduct.EventController do
  use Phoenix.Controller
#  use Jazz
  alias CodeForConduct.Router
  alias CodeForConduct.Event

  def index(conn, _params) do
    render conn, "index", events: Repo.all(Event)
  end
end
