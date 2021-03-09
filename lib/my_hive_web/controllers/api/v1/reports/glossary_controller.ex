defmodule MyHiveWeb.Api.V1.GlossaryController do 
  use MyHiveWeb, :controller
  alias MyHive.{
    Repo, Reports, Accounts
  }

  def index(conn, %{"q" => query}) do
    glossary_items = Reports.glossary_items_like(query)
    render(conn, "index.json", %{
      items: glossary_items
    })
  end

end