defmodule MyHiveWeb.ApiErrorView do
  use MyHiveWeb, :view
  
  def render("error.json", %{changeset: changeset}) do
    %{
      errors: ["You are not authorized to perform this action"]
    }
  end

  
end
