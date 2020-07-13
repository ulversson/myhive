defmodule MyHive.PatientImporter do
  import MyHive.JsonLoader
  alias MyHive.ContactBook


  def call do
    {:ok, data} = json_path("patients.json") |> get_json()
    Enum.each(data, fn  json_pat ->
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
