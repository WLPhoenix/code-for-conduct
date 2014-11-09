defmodule CodeForConduct.Event do
  use Ecto.Model
  alias CodeForConduct.Report

  validate event,
    ebid: present(),
    ownerid: present()

  schema "events" do
    field :ebid, :string
    field :ownerid, :string
    field :cofc, :string
    has_many :reports, Report
  end
end
