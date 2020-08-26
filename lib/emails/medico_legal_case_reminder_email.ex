defmodule MyHive.Emails.MedicoLegalCaseReminderEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  def call(user, notification, medico_legal_case) do
    base_email()
    |> to(user.email)
    |> subject(notification.topic)
    |> assign(:user, user)
    |> assign(:medico_legal_case, medico_legal_case)
    |> render("remind_email.html")
  end

  def deliver(user, notification, medico_legal_case) do
    call(user, notification, medico_legal_case) |> MyHive.Mailer.deliver_now
  end

  defp base_email do
    new_email()
    |> from("info@my-hive.uk")
    |> put_html_layout({MyHiveWeb.LayoutView, "email.html"})
  end

end
