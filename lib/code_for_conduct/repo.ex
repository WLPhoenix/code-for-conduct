defmodule CodeForConduct.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url System.get_env("DATABASE_URL")
  end

  def priv do
    app_dir(:code_for_conduct, "priv/repo")
  end
end
