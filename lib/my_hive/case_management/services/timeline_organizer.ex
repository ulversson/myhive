defmodule MyHive.CaseManagement.Services.TimelineOrganizer do

  alias MyHive.{
    Repo, CaseManagement
  }
  alias MyHive.CaseManagement.MedicoLegalCaseStatus

  def call(statuses) do
    statuses
      |> Enum.with_index
      |> Enum.each(fn({stage, index}) ->
        order = index
        stage =  stage |> elem(1)
        stage["id"]
          |> CaseManagement.find_status_by_id()
          |> MedicoLegalCaseStatus.changeset(%{order: order})
          |> Repo.update()
      end)
  end

end
