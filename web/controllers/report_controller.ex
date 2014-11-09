defmodule CodeForConduct.ReportController do
  use Phoenix.Controller
#  use Jazz
  alias CodeForConduct.Router
  alias CodeForConduct.Report
  alias CodeForConduct.Event

  def index(conn, %{:event_id => event_id}) do
    event = Repo.get(Event, event_id)
    render conn, "index", events: Repo.all(event.reports)
  end
end
