defmodule CodeForConduct.Event do
  use Ecto.Model

  validate event,
    ebid: present(),
    ownerid: present()

  schema "events" do
    field :ebid, :string
    field :ownerid, :string
    field :cofc, :string
  end
end
