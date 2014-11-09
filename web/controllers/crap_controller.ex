defmodule CodeForConduct.CrapController do
  use Phoenix.Controller
  import HTTPoison
  import Poison
  import EventBrite

  alias CodeForConduct.Router
  alias CodeForConduct.Repo
  alias CodeForConduct.Event

  plug :action

  def list_eb(conn, _params) do
    case get_session(fetch_session(conn), :eb_token) do
      nil ->
        redirect conn, to: CodeForConduct.Router.Helpers.page_path(:auth)
      token ->
        ei = EventBrite.get_event_info(token)
        json conn, ei
    end
  end

  defp calculate_initial_cofc(_) do
    "Come on, don't be an asshole. Really, just don't."
  end

  def create_conduct_text(conn, params) do
    %{"eventID" => ebid} = params
    questions = ""
    token = get_session(conn, :eb_token)
    e = EventBrite.get_single_event_info(token, ebid)   
    cofc = calculate_initial_cofc(questions)

    event = %Event{ebid: ebid, cofc: cofc, ownerid: "me"}
    event = Repo.insert(event)

    json conn, %{:eventID => ebid, :htmlData => cofc, :conductID => event.id}
  end

  def create_conduct(conn, params) do
    %{"conductID" => id} = params
    %{"htmlData" => cofc} = params

    event = Repo.get(Event, id)

    event = %{event | cofc: cofc}
    Repo.update(event)

    json conn, %{:id => event.id, :cocHTML => cofc, :htmlData => cofc, :conductID => event.id}
  end

  def edit_conduct(conn, _params) do
    render conn, "edit_conduct.html"
  end

  def send_info(conn, params) do
    %{"conductID" => id} = params

    event = Repo.get(Event, id)

    json conn, %{:id => event.id, :conductID => event.id}
  end
    
end
