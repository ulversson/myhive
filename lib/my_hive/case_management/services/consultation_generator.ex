defmodule MyHive.CaseManagement.Services.ConsultationGenerator do

  alias MyHive.{
    CaseManagement, FileManager
  }

  def call(consultation, user_id) do
    mlc = consultation["medico_legal_case_id"]
      |> medico_legal_case()
    data = Map.merge(consultation, %{
      "user_id" => user_id,
      "patient_id" =>  mlc.patient_id
    })
    with {:ok, cons} <- CaseManagement.create_consultation(data),
        {:ok, folder} <- create_file_assets_folder(mlc.folder_id, user_id),
        {:ok, _} <- create_consultation_folder(cons, folder, mlc.patient_id)
      do
        {:ok, cons}
      else
        {:error, changeset} ->
          {:error, changeset}
    end
  end

  def medico_legal_case(mlc_id) do
    CaseManagement.get_medico_legal_case!(mlc_id)
  end

  defp create_file_assets_folder(parent_id, user_id) do
    FileManager.create_folder(%{
      parent_id: parent_id,
      user_id: user_id,
      name: "_consultation",
      folder_type: "medico_legal_case_consultation"
    })
  end

  defp create_consultation_folder(cons, folder, patient_id) do
    require IEx; IEx.pry
    CaseManagement.create_consultation_folder(%{
      folder_id: folder.id,
      patient_consultation_id: cons.id,
      patient_id: patient_id
    })
  end
end
