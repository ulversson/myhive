defmodule MyHiveWeb.EmailTemplates.EmailTemplateController do
  use MyHiveWeb, :controller
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root}
    when action not in [:create, :update]
  alias MyHive.EmailTemplates
  alias MyHive.EmailTemplates.EmailTemplate
  alias MyHiveWeb.FallbackController
  def index(conn, _params) do
    conn |> render(
      "index.html",
      templates: EmailTemplates.ordered_all
    )
  end

  def new(conn, _params) do
    changeset = EmailTemplate.changeset(%EmailTemplate{}, %{})
    conn |> render("new.html", %{
      changeset: changeset,
      template: changeset
    })
  end

  def edit(conn, %{"id" => id}) do
    template = EmailTemplates.get_by_id(id)
    changeset = template |> EmailTemplate.changeset(%{})
    conn |> render(
      "edit.html",
      changeset: changeset,
      template: template
    )
  end

  def update(conn, %{"id" => id, "email_template" => email_template }) do
    template = EmailTemplates.get_by_id(id)
    changeset = template |> EmailTemplate.changeset(%{})
    case EmailTemplates.update_email_template(template, email_template) do
      {:ok, updated} ->
        conn
         |> put_flash(:info, "Template updated")
         |> json(%{
           "success" => true,
           "status" => "ok"
         })
      {:error, changeset} ->
        conn
          |> put_status(422)
          |> FallbackController.call({:error, changeset})
    end
  end

end
