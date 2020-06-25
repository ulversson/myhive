defmodule MyHive.TimeSheet.Services.XLSXRenderer do
  alias Elixlsx.{Workbook, Sheet}
  alias MyHive.TimeSheet.TimeEntry
  alias MyHive.TimeSheet.Services.DurationCalculator

  @header [
    "ID",
    "Duration",
    "Task",
    "Start - End",
    "Case",
    "Note Issued"
  ]

  @header_more [
    "ID",
    "Duration",
    "Owner",
    "Task",
    "Start - End",
    "Case",
    "Note Issued"
  ]

  def call(entries, extended) do
    %Workbook{sheets: [%Sheet{
      name: "Time Sheet",
      rows: render_rows(entries, extended)}
    ]}
  end

  def render_rows(entries, extended) do
    if extended do
      rows = entries |> Enum.map(&(row_more(&1)))
      [@header_more] ++ rows ++ summary(entries)
    else
      rows = entries |> Enum.map(&(row(&1)))
      [@header] ++ rows ++ summary(entries)
    end
  end

  def row(time_entry) do
    [
      time_entry.id,
      TimeEntry.duration(time_entry),
      time_entry.description,
      TimeEntry.from_to(time_entry),
      (time_entry.medico_legal_case.patient.first_name <> " " <> time_entry.medico_legal_case.patient.last_name),
      (if (time_entry.note_issued), do: "YES", else: "NO")
    ]
  end

  def row_more(time_entry) do
    [
      time_entry.id,
      TimeEntry.duration(time_entry),
      (time_entry.owner.first_name <> " " <> time_entry.owner.last_name),
      time_entry.description,
      TimeEntry.from_to(time_entry),
      (time_entry.medico_legal_case.patient.first_name <> " " <> time_entry.medico_legal_case.patient.last_name),
      (if (time_entry.note_issued), do: "YES", else: "NO")
    ]
  end

  def summary(entries) do
    [["Total time:", DurationCalculator.call(entries)]]
  end
end
