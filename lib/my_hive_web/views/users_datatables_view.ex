defmodule MyHiveWeb.UsersDatatablesView do 

  use MyHiveWeb, :view

  def render("index.json", %{users: users, draw_number: draw_number}) do
    %{ recordsTotal:  users.total_entries,
       draw: draw_number,
       recordsFiltered: users.total_entries,
       data: Enum.map(users, &user_json/1)
     }
  end

  def user_json(user) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      phone_number: user.phone_number,
      roles: user.roles
    }
  end
end  