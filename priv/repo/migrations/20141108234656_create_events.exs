defmodule CodeForConduct.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def up do
    ["CREATE TABLE IF NOT EXISTS events(id serial primary key, ebid text)"]
  end

  def down do
    "DROP TABLE events"
  end
end
