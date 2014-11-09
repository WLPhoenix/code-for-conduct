defmodule CodeForConduct.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope alias: CodeForConduct do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/auth", PageController, :auth, as: :page
    get "/eb/evt", CrapController, :list_eb
    resources "events", EventController do 
      resources "reports", ReportController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
