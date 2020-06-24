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

  def call(entries) do
    rows = entries |> Enum.map(&(row(&1)))
    %Workbook{sheets: [%Sheet{
      name: "Time Sheet", rows: [@header] ++ rows ++ summary(entries)}
    ]}
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

  def summary(entries) do
    [["Total time:", DurationCalculator.call(entries)]]
  end
end
