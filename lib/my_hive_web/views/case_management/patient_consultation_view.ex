defmodule MyHiveWeb.PatientConsultationView do
  use MyHiveWeb, :view

  def render("consultations.json", %{consultations: consultations}) do
    %{
      data: Enum.map(consultations, &consultation_item/1)
    }
  end

  defp consultation_item(consultation) do
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
      note: consultation.note
    }
  end
end
