defmodule MyHiveWeb.GlossaryOfTermController do
  use MyHiveWeb, :controller
  plug :put_layout, {MyHiveWeb.LayoutView, :root}
  
  alias MyHive.Reports
  alias MyHive.Reports.GlossaryOfTerm
  alias MyHiveWeb.FallbackController

  def index(conn, _) do
    render(conn, "index.html")
  end

  def add(conn, _) do 
    changeset = GlossaryOfTerm.changeset(%GlossaryOfTerm{}, %{})
    render(conn, "new.html", %{
      changeset: changeset
    })
  end

  def create(conn, %{"glossary_item" => glossary_item}) do 
    case Reports.create_glossary_item(glossary_item) do
      {:ok, _post} ->
        conn
          |> put_flash(:info, "Your glossary item has been successfully added")
          |> redirect(to: Routes.glossary_of_term_path(conn, :index))
      {:error, changeset} ->
        conn |> FallbackController.call({:error, changeset})
    end
  end
end