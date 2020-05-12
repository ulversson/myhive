defmodule MyHive.CaseManagement.MedicoLegalCaseNotificationData do
  alias MyHive.Repo
  def case_data(medico_legal_case) do
    medico_legal_case = Repo.preload(medico_legal_case, [:patient, :user])
    %{
      topic: topic(medico_legal_case),
      icon: icon_from_case_status(medico_legal_case.status),
      body: body_message(medico_legal_case),
    }
  end

  def topic(medico_legal_case) do
    "[myHive] - You have a #{medico_legal_case.status} matter"
  end

  defp icon_from_case_status(status) do
    case status do
      "pending" -> "fas fa-business-time"
      "current" -> "fas fa-briefcase"
      "settled" -> "fas fa-clipboard-check"
    end
  end

  defp patient_name(medico_legal_case) do
    medico_legal_case.patient.first_name <> " " <> medico_legal_case.patient.last_name
  end

  def body_message(medico_legal_case) do
    body = "You have a #{medico_legal_case.status} matter: #{patient_name(medico_legal_case)}. "
    case medico_legal_case.status do
      "pending" ->
        body <>  "Please do not start preparing your report until we notify you further. Happy my-hiving!"
      "current" ->
        body <> "Please start preparing your report, which we expect to receive within 6-weeks of today’s date unless notified otherwise."
      "settled" ->
        body <> settled_body(medico_legal_case)
    end
    body <> "\n Happy myHiving!"
  end

  defp settled_body(medico_legal_case) do
    "We are pleased to notify you that the case of #{patient_name(medico_legal_case)} has settled.
    Please do not carry out any further work on this file; if you have outstanding work please notify
    us as soon as practicable. We have requested feedback from our instructing party; as soon as feedback is provided, we will notify you.
    In the interim, we would like to thank you for your time on this matter."
  end
end
