defmodule MyHive.TimeSheet.TimeEntry do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyHive.Accounts.User
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
    field :start_date, :naive_datetime
    belongs_to :owner, User
    belongs_to :medico_legal_case, MedicoLegalCase
    timestamps()
  end

  @doc false
  def changeset(time_entry, attrs) do
    time_entry
    |> cast(attrs, [:medico_legal_case_id, :owner_id, :start_date, :end_date, :description, :note, :note_issued])
    |> validate_required([:medico_legal_case_id, :owner_id, :start_date, :end_date, :description])
  end

  def duration_in_seconds(time_entry) do
    if Timex.before?(time_entry.end_date, time_entry.start_date) do
      new_end = Timex.shift(time_entry.end_date, days: 1)
      Timex.diff(new_end, time_entry.start_date, :seconds)
    else
      Timex.diff(time_entry.end_date, time_entry.start_date, :seconds)
    end
  end

  def duration(time_entry) do
    duration_in_seconds(time_entry)
    |> Timex.Duration.from_seconds()
    |> Duration.Formatter.format(:humanized)
  end

  def from_to(time_entry) do
    start_time =  Timex.format!(time_entry.start_date, "%d/%m/%Y %H:%M", :strftime)
    end_time = Timex.format!(time_entry.end_date, "%d/%m/%Y %H:%M", :strftime)
    "#{start_time} - #{end_time}"
  end
end
