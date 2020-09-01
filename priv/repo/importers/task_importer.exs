defmodule MyHive.TimeSheetImporter do
  import MyHive.JsonLoader
  import Ecto.Query
  alias MyHive.{TimeSheet,ContactBook, Repo, Accounts}
  alias MyHive.CaseManagement.MedicoLegalCase

  def call do
    {:ok, data} = json_path("tasks.json") |> get_json()
    Enum.each(data, fn  task ->
      person = ContactBook.by_first_and_last_name(
        task["patient"]["first_name"],
        task["patient"]["last_name"],
        "Patient"
      )
      user = Accounts.by_first_and_last_name(task["user"]["first_name"], task["user"]["last_name"])
      mlc = get_case_for_patient(person.id)
      if is_nil(mlc) == false and is_nil(user) == false do
        TimeSheet.create_time_entry(%{
          description: task["name"],
          start_date: task["start_date"],
          end_date: task["end_date"],
          note: task["note"],
          owner_id: user.id,
          medico_legal_case_id: mlc.id,
          note_issued: task["note_issued"]
        })
      end
    end)
  end

  defp get_case_for_patient(patient_id) do
    query = from mlc in MedicoLegalCase,
    where: mlc.patient_id == ^patient_id,
    limit: 1
    Repo.one(query)
  end

end
MyHive.TimeSheetImporter.call
