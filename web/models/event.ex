defmodule CodeForConduct.Event do
  use Ecto.Model

  validate event,
    ebid: present()

  schema "events" do
    field :ebid, :string
  end
end
