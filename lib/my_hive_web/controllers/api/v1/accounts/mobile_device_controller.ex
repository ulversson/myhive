defmodule MyHiveWeb.Api.V1.Accounts.MobileDeviceController do
  use MyHiveWeb, :controller
  alias MyHive.Accounts

  def create(conn, %{"token" => token, "os" => os}) do
    user_id = conn.private.guardian_default_resource.id
    case Accounts.create_mobile_device(%{
      user_id: user_id,
      token: token,
      os: os
    }) do
      {:ok, dev}  ->
        Accounts.delete_devices(user_id, os, dev.id)
        conn |> json(%{success: true})
      {:error, changeset} ->
        conn |> MyHiveWeb.FallbackController.call({:error, changeset})
      end
    end

    def create(conn, _) do
      case Accounts.create_mobile_device(%{
        user_id: nil,
        token: nil,
        os: nil
      }) do
        {:ok, dev}  ->
          conn |> json(%{success: true})
        {:error, changeset} ->
          conn |> MyHiveWeb.FallbackController.call({:error, changeset})
        end
      end
  end
