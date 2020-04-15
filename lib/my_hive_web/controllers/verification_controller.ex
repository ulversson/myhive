defmodule MyHiveWeb.VerificationController do
  use MyHiveWeb, :controller
  alias MyHive.Accounts
  alias MyHive.Accounts.Token
  alias MyHive.Emails.ConfirmationInstructionsEmail

  def new(conn, %{"token" => token}) do
    with {:ok, user_id} <- Token.verify_new_account_token(token) do
      try do
        user = Accounts.get_user!(user_id)
        Accounts.mark_as_verified(user)
      rescue
        _ ->
        render(conn |> put_layout("login.html"), "invalid_token.html")
      end
      render(conn |> put_layout("login.html"), "new.html")
    else
     _ ->
      render(conn |> put_layout("login.html"), "invalid_token.html")
    end
  end

  def new(conn, _) do
    conn
    |> put_flash(:error, "The verification link is invalid.")
    |> redirect(to: "/")
  end

  def resend_instructions(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    if user do
      ConfirmationInstructionsEmail.deliver(user)
      conn |> json(%{
        message: "Instructions has been successfully sent.",
        status: "ok",
        id: user.id
      })
      else
       conn |>
          put_status(422) |> json(%{
            message: "Unable to resend instructions",
            status: "failed"
          })
    end
  end

end
