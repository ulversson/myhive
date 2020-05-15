defmodule MyHive.Emails.FileManagerEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  def call(user, notification) do
    base_email()
    |> to(user.email)
    |> subject(notification.topic)
    |> assign(:user, user)
    |> assign(:body, notification.body)
    |> render("file_manager_email.html")
  end

  def deliver(user, notification) do
    call(user, notification) |> MyHive.Mailer.deliver_now
  end

  defp base_email do
    new_email()
    |> from("info@my-hive.uk")
    |> put_html_layout({MyHiveWeb.LayoutView, "email.html"})
  end

end
