defmodule MyHive.UsersImporter do
  import MyHive.JsonLoader
  alias MyHive.{
    Accounts, Saas, Chat, Organizer
  }
  alias MyHive.Accounts.User


  def call do
    {:ok, data} = json_path("users.json") |> get_json()
    Enum.each(data, fn  user_json ->
      email = user_json["email"]
      case Accounts.get_by_email(email) do
        {:error , _} ->
          {:ok, user} = Accounts.create_user(%{
            first_name: user_json["forename"],
            last_name: user_json["surname"],
            email: user_json["email"],
            phone_number: user_json["primary_number"],
            roles: roles_from_json(user_json)
          })
          Saas.add_to_account(user, 1)
          Chat.add_to_lobby(user.id)
          Organizer.create_calendar_for_user(user, %{"name" => "#{User.name_for(user)}'s Calendar"})
        {:ok, _user} -> nil
      end
    end)
  end

  defp roles_from_json(user_json) do
    case user_json["roles_mask"] do
      6 -> ["expert"]
      4 -> ["expert"]
      7 -> ["admin"]
    end
  end

end
MyHive.UsersImporter.call
