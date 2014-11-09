defmodule CodeForConduct.CrapController do
  use Phoenix.Controller
  import HTTPoison
  import Poison
  import EventBrite

  alias CodeForConduct.Router

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
end
