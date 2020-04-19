defmodule MyHiveWeb.CaseManagement.CasePersonController do
  use MyHiveWeb, :controller

  alias MyHive.ContactBook
  alias MyHive.ContactBook.CasePerson

  action_fallback MyHiveWeb.FallbackController

  def index(conn, _params) do
    people = ContactBook.list_people()
    render(conn, "index.json", people: people)
  end

  def create(conn, %{"case_person" => case_person_params}) do
    with {:ok, %CasePerson{} = case_person} <- ContactBook.create_case_person(case_person_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.case_person_path(conn, :show, case_person))
      |> render("show.json", case_person: case_person)
    end
  end

  def show(conn, %{"id" => id}) do
    case_person = ContactBook.get_case_person!(id)
    render(conn, "show.json", case_person: case_person)
  end

  def update(conn, %{"id" => id, "case_person" => case_person_params}) do
    case_person = ContactBook.get_case_person!(id)

    with {:ok, %CasePerson{} = case_person} <- ContactBook.update_case_person(case_person, case_person_params) do
      render(conn, "show.json", case_person: case_person)
    end
  end

  def delete(conn, %{"id" => id}) do
    case_person = ContactBook.get_case_person!(id)

    with {:ok, %CasePerson{}} <- ContactBook.delete_case_person(case_person) do
      send_resp(conn, :no_content, "")
    end
  end
end
