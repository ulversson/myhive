defmodule MyHiveWeb.Api.V1.ContactBook.PersonSearchController do
  use MyHiveWeb, :controller
  alias MyHive.Repo
  alias MyHive.ContactBook
  action_fallback MyHiveWeb.ApiFallbackController

  def index(conn, %{"q"=> query, "type" => person_type} = params) do

    page = ContactBook.people_by_name(query, person_type)
      |> Repo.paginate(params)

    render conn, :index,
      people: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
  end
end
