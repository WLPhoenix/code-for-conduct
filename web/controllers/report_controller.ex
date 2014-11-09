defmodule CodeForConduct.ReportController do
  use Phoenix.Controller
  alias CodeForConduct.Repo
  alias CodeForConduct.Report
  alias CodeForConduct.Event

  plug :action

  def index(conn, %{"event_id" => event_id}) do
    { iid, _ } = Integer.parse(event_id)
    event = Repo.get(Event, iid)
    json conn, ures(Repo.all(event.reports))
  end

  def show(conn, %{"id" => id}) do
    { iid, _ } = Integer.parse(id)
    json conn, ure(Repo.get(Report, iid))
  end

  defp ures([e|rest]) do
    [ure(e) | ures(rest)]
  end 

  defp ures([]) do
    []  
  end 

  defp ure(e) do
    %{ 
       :event_id => e.event_id, 
       :id => e.id, 
       :reporterid => e.reporterid, 
       :complaint => e.complaint
     }
  end 

end
