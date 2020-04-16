defmodule MyHiveWeb.MedicoLegalCaseControllerTest do
  use MyHiveWeb.ConnCase

  alias MyHive.CaseManagement
  alias MyHive.CaseManagement.MedicoLegalCase

  @create_attrs %{
    case_summary: "some case_summary",
    claimant_defendant: true,
    due_date: ~D[2010-04-17],
    folder_id: 42,
    note: "some note",
    notifications_disabled: true,
    patient_deceased: true,
    status: "some status",
    user_id: 42
  }
  @update_attrs %{
    case_summary: "some updated case_summary",
    claimant_defendant: false,
    due_date: ~D[2011-05-18],
    folder_id: 43,
    note: "some updated note",
    notifications_disabled: false,
    patient_deceased: false,
    status: "some updated status",
    user_id: 43
  }
  @invalid_attrs %{case_summary: nil, claimant_defendant: nil, due_date: nil, folder_id: nil, note: nil, notifications_disabled: nil, patient_deceased: nil, status: nil, user_id: nil}

  def fixture(:medico_legal_case) do
    {:ok, medico_legal_case} = CaseManagement.create_medico_legal_case(@create_attrs)
    medico_legal_case
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all medico_legal_cases", %{conn: conn} do
      conn = get(conn, Routes.medico_legal_case_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create medico_legal_case" do
    test "renders medico_legal_case when data is valid", %{conn: conn} do
      conn = post(conn, Routes.medico_legal_case_path(conn, :create), medico_legal_case: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.medico_legal_case_path(conn, :show, id))

      assert %{
               "id" => id,
               "case_summary" => "some case_summary",
               "claimant_defendant" => true,
               "due_date" => "2010-04-17",
               "folder_id" => 42,
               "note" => "some note",
               "notifications_disabled" => true,
               "patient_deceased" => true,
               "status" => "some status",
               "user_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.medico_legal_case_path(conn, :create), medico_legal_case: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update medico_legal_case" do
    setup [:create_medico_legal_case]

    test "renders medico_legal_case when data is valid", %{conn: conn, medico_legal_case: %MedicoLegalCase{id: id} = medico_legal_case} do
      conn = put(conn, Routes.medico_legal_case_path(conn, :update, medico_legal_case), medico_legal_case: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.medico_legal_case_path(conn, :show, id))

      assert %{
               "id" => id,
               "case_summary" => "some updated case_summary",
               "claimant_defendant" => false,
               "due_date" => "2011-05-18",
               "folder_id" => 43,
               "note" => "some updated note",
               "notifications_disabled" => false,
               "patient_deceased" => false,
               "status" => "some updated status",
               "user_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, medico_legal_case: medico_legal_case} do
      conn = put(conn, Routes.medico_legal_case_path(conn, :update, medico_legal_case), medico_legal_case: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete medico_legal_case" do
    setup [:create_medico_legal_case]

    test "deletes chosen medico_legal_case", %{conn: conn, medico_legal_case: medico_legal_case} do
      conn = delete(conn, Routes.medico_legal_case_path(conn, :delete, medico_legal_case))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.medico_legal_case_path(conn, :show, medico_legal_case))
      end
    end
  end

  defp create_medico_legal_case(_) do
    medico_legal_case = fixture(:medico_legal_case)
    {:ok, medico_legal_case: medico_legal_case}
  end
end
