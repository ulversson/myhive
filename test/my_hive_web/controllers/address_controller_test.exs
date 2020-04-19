defmodule MyHiveWeb.AddressControllerTest do
  use MyHiveWeb.ConnCase

  alias MyHive.ContactBook
  alias MyHive.ContactBook.Address

  @create_attrs %{
    address_line1: "some address_line1",
    address_line2: "some address_line2",
    address_line3: "some address_line3",
    addressable_id: 42,
    addressable_type: "some addressable_type",
    email: "some email",
    name: "some name",
    phone_number: "some phone_number"
  }
  @update_attrs %{
    address_line1: "some updated address_line1",
    address_line2: "some updated address_line2",
    address_line3: "some updated address_line3",
    addressable_id: 43,
    addressable_type: "some updated addressable_type",
    email: "some updated email",
    name: "some updated name",
    phone_number: "some updated phone_number"
  }
  @invalid_attrs %{address_line1: nil, address_line2: nil, address_line3: nil, addressable_id: nil, addressable_type: nil, email: nil, name: nil, phone_number: nil}

  def fixture(:address) do
    {:ok, address} = ContactBook.create_address(@create_attrs)
    address
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all addresses", %{conn: conn} do
      conn = get(conn, Routes.address_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create address" do
    test "renders address when data is valid", %{conn: conn} do
      conn = post(conn, Routes.address_path(conn, :create), address: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.address_path(conn, :show, id))

      assert %{
               "id" => id,
               "address_line1" => "some address_line1",
               "address_line2" => "some address_line2",
               "address_line3" => "some address_line3",
               "addressable_id" => 42,
               "addressable_type" => "some addressable_type",
               "email" => "some email",
               "name" => "some name",
               "phone_number" => "some phone_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.address_path(conn, :create), address: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update address" do
    setup [:create_address]

    test "renders address when data is valid", %{conn: conn, address: %Address{id: id} = address} do
      conn = put(conn, Routes.address_path(conn, :update, address), address: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.address_path(conn, :show, id))

      assert %{
               "id" => id,
               "address_line1" => "some updated address_line1",
               "address_line2" => "some updated address_line2",
               "address_line3" => "some updated address_line3",
               "addressable_id" => 43,
               "addressable_type" => "some updated addressable_type",
               "email" => "some updated email",
               "name" => "some updated name",
               "phone_number" => "some updated phone_number"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, address: address} do
      conn = put(conn, Routes.address_path(conn, :update, address), address: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete address" do
    setup [:create_address]

    test "deletes chosen address", %{conn: conn, address: address} do
      conn = delete(conn, Routes.address_path(conn, :delete, address))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.address_path(conn, :show, address))
      end
    end
  end

  defp create_address(_) do
    address = fixture(:address)
    {:ok, address: address}
  end
end
