defmodule MyHive.TimeSheet.TimeEntry do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {
    Jason.Encoder,
    only: [:description, :end_date, :medico_legal_case_id, :note,
      :owner_id, :start_date]
  }
  schema "time_sheet_time_entries" do
    field :description, :string
    field :end_date, :naive_datetime
    field :medico_legal_case_id, :integer
    field :note, :string
    field :owner_id, :integer
    field :start_date, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(time_entry, attrs) do
    time_entry
    |> cast(attrs, [:medico_legal_case_id, :owner_id, :start_date, :end_date, :description, :note])
    |> validate_required([:medico_legal_case_id, :owner_id, :start_date, :end_date, :description])
  end
end
