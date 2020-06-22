defmodule MyHiveWeb.Api.V1.TimeSheet.TimeEntryController do

  use MyHiveWeb, :controller
  alias MyHive.TimeSheet
  action_fallback MyHiveWeb.FallbackController

  def create(conn, %{"time_entry" => time_entry_params}) do
    case TimeSheet.create_time_entry(time_entry_params) do
      {:ok, time_entry} ->
        conn |> json(time_entry)
      {:error, changeset} ->
        conn |> MyHiveWeb.FallbackController.call({:error, changeset})
    end
  end
end
