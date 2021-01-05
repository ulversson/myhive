defmodule MyHive.CaseManagement.Services.TimelineOrganizer do

  alias MyHive.{
    Repo, CaseManagement
  }
  alias MyHive.CaseManagement.MedicoLegalCaseStatus

  def call(statuses) do
    statuses
      |> Enum.map(fn i ->
        put_elem(i, 0, String.to_integer(elem(i, 0)))
      end)
      |> Enum.sort_by(&(elem(&1, 0)))
      |> Enum.each(fn({index, stage}) ->
        IO.puts("Stage: #{stage["name"]}, index: #{index}, order: #{stage["order"]}")
        stage["id"]
          |> CaseManagement.find_status_by_id()
          |> MedicoLegalCaseStatus.changeset(%{order: index+1})
          |> Repo.update()
      end)
  end

end
