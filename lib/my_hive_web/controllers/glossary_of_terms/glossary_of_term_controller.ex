defmodule MyHiveWeb.GlossaryOfTermController do
  use MyHiveWeb, :controller
  plug :put_layout, {MyHiveWeb.LayoutView, :root} when action not in [:for_letter, :search]
  
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

  def for_letter(conn, %{"letter" => letter}) do
    glossary_items = Reports.glossary_items_for_letter(letter)
    render(conn, "_items.html", %{
      items: (glossary_items |> Enum.with_index())
    })
  end

  def search(conn, %{"q" => query}) do
    glossary_items = Reports.glossary_items_like(query)
    render(conn, "_items.html", %{
      items: (glossary_items |> Enum.with_index())
    })
  end

  def create(conn, %{"glossary_item" => glossary_item}) do 
    case Reports.create_glossary_item(glossary_item) do
      {:ok, _got} ->
        conn
          |> put_flash(:info, "Your glossary item has been successfully added")
          |> redirect(to: Routes.glossary_of_term_path(conn, :index))
      {:error, changeset} ->
        conn |> FallbackController.call({:error, changeset})
    end
  end

  def update_field(conn, %{"id" => id, "field" => field, "value" => value}) do
    case Reports.got_by_id(id) do
      nil ->
        conn |> FallbackController.call({:error, :not_found})
      got ->
        Reports.update_glossay_of_term_field(got, field, value)
        conn |> json(%{
          message: "ok",
          success: true
        })
    end
  end 

  def delete(conn, %{"id" => id}) do
    case Reports.got_by_id(id) do 
      nil ->
        conn |> FallbackController.call({:error, :not_found})
      got ->
        Reports.delete_got_item(got)
        conn |> json(%{
          success: true,
          message: "Item has been removed",
          status: "ok"        
        })
    end
  end

end