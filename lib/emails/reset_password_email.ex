defmodule MyHive.Emails.ResetPasswordEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  alias MyHiveWeb.Router.Helpers, as: Routes

  def call(user) do
    base_email()
    |> assign(:user, user)
    |> assign(:change_url, Routes.forgotten_password_url(MyHiveWeb.Endpoint, :forgot_verify, token: user.reset_email_token))
    |> to(user.email)
    |> subject("[my-hive] Reset password instructions")
    |> render("reset_password_email.html")
  end

  def deliver(user) do
    call(user) |> MyHive.Mailer.deliver_now()
  end

  defp base_email do
    new_email()
    |> from("info@my-hive.uk")
    |> put_html_layout({MyHiveWeb.LayoutView, "email.html"})
  end

end
