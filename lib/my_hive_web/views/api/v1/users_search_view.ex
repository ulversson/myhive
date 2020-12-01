defmodule MyHiveWeb.UsersSearchView do
  use MyHiveWeb, :view
  alias MyHive.Accounts.User
  def render("index.json", %{
      users: users,
      page_number: page_number,
      total_pages: total_pages,
      total_entries: total_entries
    }) do
    %{ total_enttries:  total_entries,
       page: page_number,
       page_number: page_number,
       total_pages: total_pages,
       data: Enum.map(users, &user_json/1)
     }
  end

  def render("index.json", %{users: users}) do
    %{
      data: Enum.map(users, &user_json/1)
    }
  end

  def user_json(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      name: User.name_for(user)
    }
  end
end
