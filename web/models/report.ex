defmodule CodeForConduct.Report do
  use Ecto.Model
  alias CodeForConduct.Event

  validate report,
    event: present(),
    reporterId: present(),
    complaint: present()

  schema "events" do
    belongs_to :event, Event
    field :reporterid, :string
    field :complaint, :string
  end
end
