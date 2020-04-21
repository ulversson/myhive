defmodule MyHiveWeb.Api.V1.ContactBook.PersonSearchView do
  use MyHiveWeb, :view

  def render("index.json", %{
      people: people,
      page_number: page_number,
      total_pages: total_pages,
      total_entries: total_entries
    }) do
    %{ total_enttries:  total_entries,
       page: page_number,
       page_number: page_number,
       total_pages: total_pages,
       data: Enum.map(people, &person_json/1)
     }
  end

  def person_json(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name
    }
  end
end

