defmodule CodeForConduct.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
    plug Plug.Static, at: "/priv/static", from: :code_for_conduct
  end

  pipeline :api do
    plug :accepts, ~w(json)
  end

  scope alias: CodeForConduct do
    pipe_through :browser # Use the default browser stack

    #get "/", PageController, :idx
    #get "/", PageController, :index
    get "/auth", PageController, :auth, as: :page
    get "/eb/evt", CrapController, :list_eb
    post "/conduct", CrapController, :create_conduct
    post "/conduct/send", CrapController, :send_info
    post "/question", CrapController, :create_conduct_text
    get "/question", CrapController, :edit_conduct, as: :page
    resources "events", EventController do 
      resources "reports", ReportController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
