defmodule MyHiveWeb.CaseManagement.MedicoLegalCasesController do
  use MyHiveWeb, :controller
  import MyHiveWeb.Plugs.MedicoLegalCaseFilterPlug
  alias MyHive.CaseManagement.Services.{
    MedicoLegalCaseGenerator,
    MedicoLegalCaseUpdater,
    MedicoLegalCaseHoover
  }
  alias MyHive.Time.TimeHelper
  alias MyHive.CaseManagement
  alias MyHive.ContactBook.{
    Address, CasePerson
  }
  alias MyHive.CaseManagement.{
    MedicoLegalCase, InstructingParty
  }

  action_fallback MyHiveWeb.FallbackController
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root} when action not in [:create, :update]
  plug :scrub_params, "medico_legal_case" when action in [:create, :update]
  plug :filter_mlc when action in [:create, :update]

  def new(conn, _params) do
    changeset = MedicoLegalCase.changeset(
      %MedicoLegalCase{
        patient:
          %CasePerson{person_type: "Patient", addresses: [
            %Address{}
          ]},
        claimant:
          %CasePerson{person_type: "Claimant", addresses: [
            %Address{}
          ]},
        instructing_party:
          %InstructingParty{addresses: [
            %Address{}
          ]}
       }
      )

    account_id = get_session(conn, :account_id)
    render(conn, :new,
      changeset: changeset,
      account_id: account_id,
      tabs_partial: "tabs.html")
  end

  def create(conn, %{"medico_legal_case" => params}) do
    params = replace_first_level_params_with_date(params, "due_date")
    |> replace_second_level_params_with_date("patient")
    |> filter_patient
    case MedicoLegalCaseGenerator.call(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "New case has been created successfully.")
        |> send_resp(201, Routes.page_path(conn, :index))

      changeset ->
        conn
        |> put_status(422)
        |> render("422.json", changeset: changeset)
    end
  end

  def status(conn, params) do
    params["id"]
    |> CaseManagement.get_medico_legal_case!
    |> CaseManagement.change_status(params["status"])

    conn
      |> put_flash(:info, "Status has been updated")
      |> json(%{
      message: "Status has been updated",
      status: "ok"
    })
  end
  def edit(conn, %{"id" => id}) do
    medico_legal_case = CaseManagement.get_case_with_data(id)
    account_id = get_session(conn, :account_id)
    changeset = CaseManagement.change_medico_legal_case(medico_legal_case)
    render(conn, :edit,
      changeset: changeset,
      tabs_partial: "tabs_edit.html",
      mlc: medico_legal_case,
      account_id: account_id)
  end

  def update(conn, %{"id" => id, "medico_legal_case" => case_params}) do
    case_params = replace_first_level_params_with_date(case_params, "due_date")
    |> replace_second_level_params_with_date("patient")
    mlc = CaseManagement.get_case_with_data(id)
    case MedicoLegalCaseUpdater.call(mlc, case_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "New case has been created successfully.")
        |> send_resp(201, Routes.page_path(conn, :index))

      changeset ->
        conn
        |> put_status(422)
        |> render("422.json", changeset: changeset)
      end
  end

  def delete(conn, %{"id" => id}) do
    MedicoLegalCaseHoover.call(id)
    conn
      |> put_flash(:info, "Case has been successfully removed")
      |> json(%{
        message: "Case has been successfully removed",
        status: "ok"
      })
  end

  defp replace_second_level_params_with_date(params, subhash) do
    if params[subhash] && params[subhash]["date_of_birth"] do
      patient = TimeHelper.update_date_in_map(params[subhash], "date_of_birth")
      Map.put(params, subhash, patient)
    else
      params
    end
  end

  defp replace_first_level_params_with_date(params, key) do
    if params[key] do
      TimeHelper.update_date_in_map(params, "due_date")
    else
      params
    end
  end

  defp filter_patient(params) do
    if params["patient"] && map_size(params["patient"]) == 1 do
      Map.pop(params, "patient")
    else
      params
    end
  end

end
