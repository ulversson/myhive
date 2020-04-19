defmodule MyHiveWeb.CaseManagement.MedicoLegalCasesView do
  use MyHiveWeb, :view

  def render("422.json", %{changeset: changeset}) do
    Ecto.Changeset.traverse_errors(changeset, fn
      {msg, opts} -> String.replace(msg, "%{count}", to_string(opts[:count]))
      msg -> msg
    end)
  end
end
