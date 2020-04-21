defmodule MyHiveWeb.CaseManagement.MedicoLegalCasesController do
  use MyHiveWeb, :controller
  require IEx
  import MyHiveWeb.Plugs.MedicoLegalCaseFilterPlug
  alias MyHive.CaseManagement.Services.MedicoLegalCaseGenerator
  alias MyHive.Time.TimeHelper
  alias MyHive.ContactBook.{Address, CasePerson}
  alias MyHive.CaseManagement.{MedicoLegalCase, InstructingParty}
  action_fallback MyHiveWeb.FallbackController
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root} when action not in [:create]
  plug :scrub_params, "medico_legal_case" when action in [:create]
  plug :filter_mlc when action in [:create]

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
    render(conn, :new, changeset: changeset, account_id: account_id)
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
