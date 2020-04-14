defmodule MyHive.Emails.ConfirmationInstructionsEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView

  def call(user, verification_url) do
    base_email()
    |> to(user.email)
    |> subject("[myHive] Confirmation Instructions")
    |> assign(:user, user)
    |> assign(:verification_url, verification_url)
    |> render("confirmation_instructions.html")
  end

  defp base_email do
    new_email()
    |> from("info@my-hive.uk")
    |> put_html_layout({MyHiveWeb.LayoutView, "email.html"})
  end
end
# user |> MyHive.Emails.ConfirmationInstructionsEmail.call |> MyHive.Mailer.deliver_now
