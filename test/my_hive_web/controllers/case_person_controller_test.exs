defmodule MyHiveWeb.CasePersonControllerTest do
  use MyHiveWeb.ConnCase

  alias MyHive.ContactBook
  alias MyHive.ContactBook.CasePerson

  @create_attrs %{
    address_id: 42,
    date_of_birth: ~D[2010-04-17],
    date_of_death: ~D[2010-04-17],
    first_name: "some first_name",
    last_name: "some last_name",
    person_type: "some person_type"
  }
  @update_attrs %{
    address_id: 43,
    date_of_birth: ~D[2011-05-18],
    date_of_death: ~D[2011-05-18],
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    person_type: "some updated person_type"
  }
  @invalid_attrs %{address_id: nil, date_of_birth: nil, date_of_death: nil, first_name: nil, last_name: nil, person_type: nil}

  def fixture(:case_person) do
    {:ok, case_person} = ContactBook.create_case_person(@create_attrs)
    case_person
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all people", %{conn: conn} do
      conn = get(conn, Routes.case_person_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create case_person" do
    test "renders case_person when data is valid", %{conn: conn} do
      conn = post(conn, Routes.case_person_path(conn, :create), case_person: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.case_person_path(conn, :show, id))

      assert %{
               "id" => id,
               "address_id" => 42,
               "date_of_birth" => "2010-04-17",
               "date_of_death" => "2010-04-17",
               "first_name" => "some first_name",
               "last_name" => "some last_name",
               "person_type" => "some person_type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.case_person_path(conn, :create), case_person: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update case_person" do
    setup [:create_case_person]

    test "renders case_person when data is valid", %{conn: conn, case_person: %CasePerson{id: id} = case_person} do
      conn = put(conn, Routes.case_person_path(conn, :update, case_person), case_person: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.case_person_path(conn, :show, id))

      assert %{
               "id" => id,
               "address_id" => 43,
               "date_of_birth" => "2011-05-18",
               "date_of_death" => "2011-05-18",
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name",
               "person_type" => "some updated person_type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, case_person: case_person} do
      conn = put(conn, Routes.case_person_path(conn, :update, case_person), case_person: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete case_person" do
    setup [:create_case_person]

    test "deletes chosen case_person", %{conn: conn, case_person: case_person} do
      conn = delete(conn, Routes.case_person_path(conn, :delete, case_person))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.case_person_path(conn, :show, case_person))
      end
    end
  end

  defp create_case_person(_) do
    case_person = fixture(:case_person)
    {:ok, case_person: case_person}
  end
end
