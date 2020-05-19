defmodule MyHiveWeb.Helpers.ViewHelper do
  alias MyHive.Saas.ApplicationModule
  def active_link(conn, controllers, class) when is_list(controllers) do
    if Enum.member?(controllers, Phoenix.Controller.controller_module(conn)) do
      class
    else
      ""
    end
  end

  def active_link(conn, controller, class) do
    active_link(conn, [controller], class)
  end

  def error_class(errors, field) when is_list(errors) and is_atom(field) do
    case Keyword.fetch(errors, field) do
      {:ok, _} -> ""
      :error -> "has-success"
    end
  end

  def has_error_class(errors, field) when is_list(errors) and is_atom(field) do
    case Keyword.fetch(errors, field) do
      {:ok, _} -> "has-danger"
      :error -> ""
    end
  end

  def active_app_module?(account_id, module_id) do
    ApplicationModule.active_for_account?(account_id, module_id)
  end

end
