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

  def greeting(user) do
    time =  Timex.now("Europe/London")
    cond do
      time.hour > 5 && time.hour < 12 -> "Good morning #{user.first_name}"
      time.hour >= 12 && time.hour < 18 -> "Good afternoon #{user.first_name}"
      time.hour > 18 && time.hour <= 23 -> "Good evening #{user.first_name}"
      time.hour < 5 && time.hour > 0 -> "Good evening #{user.first_name}"
    end
  end

  def quote_of_the_day() do
    qt = MyHive.JsonLoader.json_content("quotes.json") |> Enum.random
    "<span style='font-style: italic;'>#{qt["quoteText"]}</span> <strong>#{qt["quoteAuthor"]}</strong>"
  end
  def active_app_module?(account_id, module_id) do
    ApplicationModule.active_for_account?(account_id, module_id)
  end

  def enabled_modules_for_account(account_id) do
    MyHive.Saas.Services.AppModulesRetriever.call(account_id)
  end

  def has_module_name_enabled?(account_id, name) do
    enabled = enabled_modules_for_account(account_id)
    names = Enum.map(enabled, fn modu -> modu.name end)
    Enum.member?(names, name)
  end

  def sidebar_modules_for_account(account_id) do
    account_id
      |> enabled_modules_for_account()
      |> Enum.filter(fn mod ->
        mod.sidebar == true
      end)
  end

end
