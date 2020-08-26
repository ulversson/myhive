defmodule MyHive.CaseManagement.MedicoLegalCaseReminder do

  alias MyHive.{
    Repo,
    CaseManagement,
    Notifications
  }
  alias MyHive.CaseManager.MedicoLegalCaseNotificationRemindResolver
  alias MyHive.CaseManagement
  def call() do
    Enum.each(CaseManagement.medico_legal_cases_due(), fn medico_legal_case ->
      medico_legal_case.users
        |> filter_those_to_notify()
        |> notify_them(medico_legal_case)
    end)
  end

  defp notify_them(users, medico_legal_case) do
    medico_legal_case = Repo.preload(medico_legal_case, [:patient])
    Enum.each(users, fn user ->
      notification = Notifications.create(user, %{
        sender_id: medico_legal_case.user_id,
        icon: "fas fa-bell",
        show_on_arrival: true,
        topic: "[my-hive] Reminder: #{patient_name(medico_legal_case)}",
        body: notification_body(user, medico_legal_case)
      })
      MedicoLegalCaseNotificationRemindResolver
        .call(user, notification, medico_legal_case)
    end)
  end

  defp filter_those_to_notify(users) do
    Enum.filter(users, fn user -> user.settings && user.settings.notifications end)
  end

  defp patient_name(medico_legal_case) do
    "#{medico_legal_case.patient.first_name} #{medico_legal_case.patient.last_name}"
  end

  defp notification_body(user, medico_legal_case) do
    ~s"""
    Reminder:
      Hello #{user.first_name},
      Your report in the matter of #{patient_name(medico_legal_case)}
      is due on #{medico_legal_case.due_date |> Timex.format!("%d/%m/%Y", :strftime)}
      If you have not already completed your report, please do so and return to the case manager.
      If there are any issues getting the report to us by #{medico_legal_case.due_date |> Timex.format!("%d/%m/%Y", :strftime)}
      please notify us immediately as delays can impact upon us being able to recover your full fee.
    """
  end

end
