defmodule MyHiveWeb.PatientConsultationView do
  use MyHiveWeb, :view
  alias MyHive.FileManager.FileLinkResolver
  alias MyHive.CaseManagement.PatientConsultation
  alias MyHive.{
    Repo, FileManager
  }

  def render("consultations.json", %{consultations: consultations, user_id: user_id}) do
    %{
      data: Enum.map(consultations, fn cons -> consultation_item(cons, user_id) end)
    }
  end

  def render("consultation.json", %{consultation: consultation, user_id: user_id}) do
    consultation_item(consultation, user_id)
  end

  defp consultation_item(consultation, user_id) do
    %{
      medico_legal_case_id: consultation.medico_legal_case_id,
      patient_id: consultation.patient_id,
      id: consultation.id,
      covid_consent: consultation.covid_consent,
      consultation_date: consultation.consultation_date,
      blood_pressure: consultation.blood_pressure,
      temperature: consultation.temperature,
      weight: consultation.weight,
      height: consultation.height,
      bmi: consultation.bmi,
      note: consultation.note,
      photo_id: photo_id_link(consultation, user_id),
      root_folder_id: patient_consultation_root(consultation)
    }
  end

  defp patient_consultation_root(consultation) do
    consultation = Repo.preload(consultation, [:folders])
    consultation.folders
      |> List.first
      |> get_root_folder()
  end

  defp get_root_folder(folder) when is_nil(folder) == true do
    ""
  end

  defp get_root_folder(folder) when is_nil(folder) == false do
    folder.id
  end

  defp photo_id_link(consultation, user_id) do
    PatientConsultation.photo_id(consultation, user_id)
  end
end
