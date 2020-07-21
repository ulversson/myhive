defmodule MyHive.MedicoLegalCaseImporter do
  import MyHive.JsonLoader
  alias MyHive.{
    CaseManagement, Accounts, ContactBook
  }
  alias MyHive.CaseManagement.Services.MedicoLegalCaseGenerator

  def call do
    {:ok, data} = json_path("mlc.json") |> get_json()
    {:ok, instructing_party} = CaseManagement.create_instructing_party(%{name: "myHive 1 import"})
    Enum.each(data, fn  mlc_json ->
      first_name = String.split(mlc_json["patient"], " ") |> Enum.at(1)
      last_name = String.split(mlc_json["patient"], " ") |> Enum.at(0)
      patient = ContactBook.by_first_and_last_name(first_name, last_name)
      unless is_nil(patient) do
          user_ids = Enum.map(mlc_json["users"], fn email ->
            case Accounts.get_by_email(email) do
              {:ok, user} -> to_string(user.id)
              {:error, _} -> nil
            end
          end)
          params = %{
            "account_id" => 1,
            "file_reference" => file_reference(mlc_json),
            "instructed_by" => "claimant",
            "due_date" => mlc_json["due_date"],
            "instructing_party_id" => instructing_party.id,
            "new_or_existing" => "existing",
            "notifications_disabled" => mlc_json["notifications_disabled"],
            "patient_id" => patient.id,
            "user_id" => 1,
            "user_ids" => user_ids
          }
          {:ok, mlc} = MedicoLegalCaseGenerator.call(params)
          CaseManagement.change_status(mlc, mlc_json["status"])
          CaseManagement.update_created_date(mlc, created_date(mlc_json))
        end
    end)
  end

  defp file_reference(data) do
    "OLDMH-#{data["id"]}-import"
  end

  defp created_date(data) do
    {:ok, d} = Timex.parse(data["created_at"], "{ISO:Extended:Z}")
    Timex.to_naive_datetime(d) |> NaiveDateTime.truncate(:second)
  end

end
MyHive.MedicoLegalCaseImporter.call
