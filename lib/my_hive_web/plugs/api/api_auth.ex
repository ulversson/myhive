defmodule MyHiveWeb.Plugs.ApiAuth do
  import Phoenix.Controller
  alias MyHive.Accounts

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)
      _ ->
        {:error, :unauthorized}
    end
  end

  def sign_in(conn, _params) do
    conn |> MyHiveWeb.ApiFallbackController.call({:error, :unauthorized})
  end

end
