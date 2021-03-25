defmodule MyHiveWeb.Api.V1.GlossaryController do 
  use MyHiveWeb, :controller
  alias MyHive.{
    Reports
  }
  alias MyHiveWeb.FallbackController
  alias MyHiveWeb.Api.V1.ReportView

  def index(conn, %{"q" => query}) do
    glossary_items = Reports.glossary_items_like(query)
    render(conn, "index.json", %{
      items: glossary_items
    })
  end
  
  def create(conn, %{"glossary_item" => glossary_item}) do 
    case Reports.create_glossary_item(glossary_item) do
      {:ok, got} ->
        conn 
          |> put_view(ReportView)
          |> render("got.json", %{got: got})
      {:error, changeset} ->
        conn |> FallbackController.call({:error, changeset})
    end
  end

end