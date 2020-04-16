defmodule MyHive.CaseManagementTest do
  use MyHive.DataCase

  alias MyHive.CaseManagement

  describe "medico_legal_cases" do
    alias MyHive.CaseManagement.MedicoLegalCase

    @valid_attrs %{case_summary: "some case_summary", claimant_defendant: true, due_date: ~D[2010-04-17], folder_id: 42, note: "some note", notifications_disabled: true, patient_deceased: true, status: "some status", user_id: 42}
    @update_attrs %{case_summary: "some updated case_summary", claimant_defendant: false, due_date: ~D[2011-05-18], folder_id: 43, note: "some updated note", notifications_disabled: false, patient_deceased: false, status: "some updated status", user_id: 43}
    @invalid_attrs %{case_summary: nil, claimant_defendant: nil, due_date: nil, folder_id: nil, note: nil, notifications_disabled: nil, patient_deceased: nil, status: nil, user_id: nil}

    def medico_legal_case_fixture(attrs \\ %{}) do
      {:ok, medico_legal_case} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CaseManagement.create_medico_legal_case()

      medico_legal_case
    end

    test "list_medico_legal_cases/0 returns all medico_legal_cases" do
      medico_legal_case = medico_legal_case_fixture()
      assert CaseManagement.list_medico_legal_cases() == [medico_legal_case]
    end

    test "get_medico_legal_case!/1 returns the medico_legal_case with given id" do
      medico_legal_case = medico_legal_case_fixture()
      assert CaseManagement.get_medico_legal_case!(medico_legal_case.id) == medico_legal_case
    end

    test "create_medico_legal_case/1 with valid data creates a medico_legal_case" do
      assert {:ok, %MedicoLegalCase{} = medico_legal_case} = CaseManagement.create_medico_legal_case(@valid_attrs)
      assert medico_legal_case.case_summary == "some case_summary"
      assert medico_legal_case.claimant_defendant == true
      assert medico_legal_case.due_date == ~D[2010-04-17]
      assert medico_legal_case.folder_id == 42
      assert medico_legal_case.note == "some note"
      assert medico_legal_case.notifications_disabled == true
      assert medico_legal_case.patient_deceased == true
      assert medico_legal_case.status == "some status"
      assert medico_legal_case.user_id == 42
    end

    test "create_medico_legal_case/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CaseManagement.create_medico_legal_case(@invalid_attrs)
    end

    test "update_medico_legal_case/2 with valid data updates the medico_legal_case" do
      medico_legal_case = medico_legal_case_fixture()
      assert {:ok, %MedicoLegalCase{} = medico_legal_case} = CaseManagement.update_medico_legal_case(medico_legal_case, @update_attrs)
      assert medico_legal_case.case_summary == "some updated case_summary"
      assert medico_legal_case.claimant_defendant == false
      assert medico_legal_case.due_date == ~D[2011-05-18]
      assert medico_legal_case.folder_id == 43
      assert medico_legal_case.note == "some updated note"
      assert medico_legal_case.notifications_disabled == false
      assert medico_legal_case.patient_deceased == false
      assert medico_legal_case.status == "some updated status"
      assert medico_legal_case.user_id == 43
    end

    test "update_medico_legal_case/2 with invalid data returns error changeset" do
      medico_legal_case = medico_legal_case_fixture()
      assert {:error, %Ecto.Changeset{}} = CaseManagement.update_medico_legal_case(medico_legal_case, @invalid_attrs)
      assert medico_legal_case == CaseManagement.get_medico_legal_case!(medico_legal_case.id)
    end

    test "delete_medico_legal_case/1 deletes the medico_legal_case" do
      medico_legal_case = medico_legal_case_fixture()
      assert {:ok, %MedicoLegalCase{}} = CaseManagement.delete_medico_legal_case(medico_legal_case)
      assert_raise Ecto.NoResultsError, fn -> CaseManagement.get_medico_legal_case!(medico_legal_case.id) end
    end

    test "change_medico_legal_case/1 returns a medico_legal_case changeset" do
      medico_legal_case = medico_legal_case_fixture()
      assert %Ecto.Changeset{} = CaseManagement.change_medico_legal_case(medico_legal_case)
    end
  end
end
