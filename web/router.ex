defmodule CodeForConduct.Router do
  use Phoenix.Router

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/", CodeForConduct.PageController, :index, as: :pages
    get "/auth", CodeForConduct.PageController, :auth, as: :pages
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through :api
  # end
end
