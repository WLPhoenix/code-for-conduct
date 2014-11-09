defmodule CodeForConduct.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def up do
    [
      "CREATE TABLE IF NOT EXISTS events(id serial primary key, ebid text, cofc text, ownerid text)",
      "CREATE TABLE IF NOT EXISTS reports(id serial primary key, event_id integer, reporterid text, complaint text)"
    ]
  end

  def down do
    [
      "DROP TABLE reports",
      "DROP TABLE events",
    ]
  end
end
