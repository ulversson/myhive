defmodule MyHiveWeb.Api.V1.TimeSheet.TimeEntryView do
  use MyHiveWeb, :view
  alias MyHiveWeb.Api.V1.TimeSheet.TimeEntryView
  alias MyHive.TimeSheet.TimeEntry

  def render("index.json", %{time_entries: time_entries,
    page_number: page_number,
    page_size: page_size,
    total_entries: total_entries,
    total_pages: total_pages}) do
    %{data:
      render_many(time_entries, TimeEntryView, "time_entry.json"),
      page: page_number,
      limit: page_size,
      count: total_entries,
      pages: total_pages
    }
  end

  def render("time_entry.json", %{time_entry: time_entry}) do
    %{
      id: time_entry.id,
      start_date: time_entry.start_date,
      end_date: time_entry.end_date,
      description: time_entry.description,
      note: time_entry.note,
      duration: TimeEntry.duration(time_entry)
    }
  end
end
