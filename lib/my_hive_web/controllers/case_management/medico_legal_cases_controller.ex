defmodule MyHiveWeb.CaseManagement.MedicoLegalCasesController do
  use MyHiveWeb, :controller
  require IEx
  import MyHiveWeb.Helpers.MedicoLegalCaseHelper
  alias MyHive.ContactBook.CasePerson
  alias MyHive.CaseManagement
  alias MyHive.ContactBook.Address
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
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"medico_legal_case" => medico_legal_case_params}) do
    case CaseManagement.create_medico_legal_case(medico_legal_case_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Case has been created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "422.json", changeset: changeset)
    end
  end


end
