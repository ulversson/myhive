defmodule MyHiveWeb.Api.V1.Accounts.MobileDeviceController do
  use MyHiveWeb, :controller
  alias MyHive.Accounts

  def create(conn, %{"token" => token, "os" => os,
    "device_type" => device_type, "udid" => udid}) do
    user_id = conn.private.guardian_default_resource.id
    device =  Accounts.first_or_create_by(
      user_id, udid, %{
      os: os,
      device_type: device_type,
      token: token
    })
    Accounts.update_notification_token(device, token)
    conn |> json(%{success: true, id: device.id})
  end
    def create(conn, _) do
      case Accounts.create_mobile_device(%{
        user_id: nil,
        token: nil,
        os: nil,
        device_type: nil,
        udid: nil
      }) do
        {:error, changeset} ->
          conn |> MyHiveWeb.FallbackController.call({:error, changeset})
        end
      end
  end
