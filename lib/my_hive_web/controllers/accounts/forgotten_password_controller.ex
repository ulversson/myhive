defmodule MyHiveWeb.ForgottenPasswordController do
  use MyHiveWeb, :controller
  plug :put_layout, "login.html"
  alias MyHive.{Accounts, Repo}
  alias MyHive.Accounts.User
  alias MyHive.Emails.ConfirmationInstructionsEmail

  def forgot(conn, %{"email" => email}) do
    email_address = email |> String.downcase() |> String.trim()
    case Repo.get_by(User, email: email_address) do
      nil ->
        conn
          |> put_flash(:error, "Email has not been found")
          |> render("forgot.html")
      user
        ->
        Accounts.set_reset_token(user)
        updated_user = Repo.get_by(User, id: user.id) #refresh token
        MyHive.Emails.ResetPasswordEmail.deliver(updated_user)
        conn
          |> put_flash(:info, "Reset instructions has been sent to provided email. Please follow them to re-gain access to my hive.")
          |> render("forgot.html")
    end
  end

  def forgot(conn, _params) do
    conn
      |> put_flash(:info, "Please enter email address registered in my-hive")
      |> render("forgot.html")
  end

  def forgot_verify(conn, %{"token" => token}) do
    case Accounts.find_by_reset_token(token) do
      nil ->
        conn
          |> put_flash(:error, "User not found. The link used might have expired or is invalid")
          |> render("forgot.html")
      user
        ->
          updated_user = Accounts.get_user!(user.id)
          require IEx; IEx.pry
          Accounts.update_user(updated_user, %{sign_in_count: 0})
          ConfirmationInstructionsEmail.deliver(updated_user)
        conn
          |> put_flash(:info, "Temporary password has been generated. Please follow instructions from the second email that has been just sent.")
          |> render("forgot.html")
    end
  end




end
