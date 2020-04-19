defmodule MyHiveWeb.AddressController do
  use MyHiveWeb, :controller

  alias MyHive.ContactBook
  alias MyHive.ContactBook.Address

  action_fallback MyHiveWeb.FallbackController

  def index(conn, _params) do
    addresses = ContactBook.list_addresses()
    render(conn, "index.json", addresses: addresses)
  end

  def create(conn, %{"address" => address_params}) do
    with {:ok, %Address{} = address} <- ContactBook.create_address(address_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.address_path(conn, :show, address))
      |> render("show.json", address: address)
    end
  end

  def show(conn, %{"id" => id}) do
    address = ContactBook.get_address!(id)
    render(conn, "show.json", address: address)
  end

  def update(conn, %{"id" => id, "address" => address_params}) do
    address = ContactBook.get_address!(id)

    with {:ok, %Address{} = address} <- ContactBook.update_address(address, address_params) do
      render(conn, "show.json", address: address)
    end
  end

  def delete(conn, %{"id" => id}) do
    address = ContactBook.get_address!(id)

    with {:ok, %Address{}} <- ContactBook.delete_address(address) do
      send_resp(conn, :no_content, "")
    end
  end
end
