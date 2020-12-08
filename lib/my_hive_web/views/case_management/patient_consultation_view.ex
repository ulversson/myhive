defmodule MyHiveWeb.PatientConsultationView do
  use MyHiveWeb, :view
  alias MyHive.FileManager.FileLinkResolver
  alias MyHive.{
    Repo, FileManager
  }


  def render("consultations.json", %{consultations: consultations, user_id: user_id}) do
    %{
      data: Enum.map(consultations, fn cons -> consultation_item(cons, user_id) end)
    }
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
      photo_id: photo_id_link(consultation, user_id)
    }
  end

  defp photo_id_link(consultation, user_id) do
    consultation = Repo.preload(consultation, [:consultation_photo_id])
    if is_nil(consultation.consultation_photo_id) == true do
      ""
    else
      file_asset = FileManager.get_file_asset!(consultation.consultation_photo_id.file_asset_id)
      FileLinkResolver.call(file_asset, user_id)
    end
  end
end
