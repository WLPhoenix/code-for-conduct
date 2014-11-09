defmodule CodeForConduct.Router do
  use Phoenix.Router

  scope "/" do
    get "/", CodeForConduct.PageController, :index, as: :pages
    get "/auth", CodeForConduct.PageController, :auth, as: :pages
  end
end
