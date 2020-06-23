defmodule MyHive.TimeSheet.TimeEntry do
  use Ecto.Schema
  import Ecto.Changeset
  alias Timex.Format.Duration
  alias MyHive.CaseManagement.MedicoLegalCase
  @derive {
    Jason.Encoder,
    only: [:description, :end_date, :medico_legal_case_id, :note,
      :owner_id, :start_date, :note_issued]
  }
  schema "time_sheet_time_entries" do
    field :description, :string
    field :end_date, :naive_datetime
    field :note, :string
    field :note_issued, :boolean, default: false
    field :owner_id, :integer
    field :start_date, :naive_datetime
    belongs_to :medico_legal_case, MedicoLegalCase
    timestamps()
  end

  @doc false
  def changeset(time_entry, attrs) do
    time_entry
    |> cast(attrs, [:medico_legal_case_id, :owner_id, :start_date, :end_date, :description, :note, :note_issued])
    |> validate_required([:medico_legal_case_id, :owner_id, :start_date, :end_date, :description])
  end

  def duration(time_entry) do
    Timex.diff(time_entry.end_date, time_entry.start_date, :seconds)
    |> Timex.Duration.from_seconds()
    |> Duration.Formatter.format(:humanized)
  end

end
