defmodule MyHive.Emails.ConfirmationInstructionsEmail do
  use Bamboo.Phoenix, view: MyHiveWeb.EmailView
  alias MyHive.Accounts
  alias MyHive.Accounts.Token
  alias MyHiveWeb.Router.Helpers, as: Routes
  def call(user, verification_url, password) do
    base_email()
    |> to(user.email)
    |> subject("[my-hive] Confirmation Instructions")
    |> assign(:user, user)
    |> assign(:password, password)
    |> assign(:verification_url, verification_url)
    |> render("confirmation_instructions.html")
  end

  defp base_email do
    new_email()
    |> from("info@my-hive.co.uk")
    |> put_html_layout({MyHiveWeb.LayoutView, "email.html"})
  end

  def deliver(user) do
    token = Token.generate_new_account_token(user)
    verification_url = Routes.verification_url(MyHiveWeb.Endpoint, :new, token: token)
    pass = Token.string_of_length(10)
    Accounts.update_password(user, pass)
    user |> call(verification_url, pass) |> MyHive.Mailer.deliver_later
  end
end
# user |> MyHive.Emails.ConfirmationInstructionsEmail.call |> MyHive.Mailer.deliver_now
