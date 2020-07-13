defmodule MyHive.PatientImporter do
  import MyHive.JsonLoader
  alias MyHive.CaseManagement


  def call do
    {:ok, data} = json_path("medico_legal_cases.json") |> get_json()
    Enum.each(data, fn  mlc_json ->
      ContactBook.create_case_person(%{
        first_name: json_pat["forename"],
        last_name: json_pat["surname"],
        person_type: "Patient",
        date_of_birth: json_pat["date_of_birth"]
      })
    end)
  end

end
MyHive.PatientImporter.call
