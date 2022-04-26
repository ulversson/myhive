defmodule MyHive.Emails.MedicoLegalCaseEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  import MyHive.CaseManagement.MedicoLegalCaseNotificationData
  alias MyHive.Repo
  def call(user, _notification, medico_legal_case) do
    medico_legal_case = Repo.preload(medico_legal_case, [:patient, :user])
    base_email()
    |> to(user.email)
    |> subject(topic(medico_legal_case))
    |> assign(:user, user)
    |> assign(:medico_legal_case, medico_legal_case)
    |> render("#{medico_legal_case.status}_case_email.html")
  end

  def deliver(user, notification, medico_legal_case) do
    call(user, notification, medico_legal_case) |> MyHive.Mailer.deliver_now
  end

  defp base_email do
    new_email()
    |> from("info@my-hive.co.uk")
    |> put_html_layout({MyHiveWeb.LayoutView, "email.html"})
  end

end
# user |> MyHive.Emails.ConfirmationInstructionsEmail.call |> MyHive.Mailer.deliver_now
