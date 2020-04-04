defmodule MyHive.Avatarly.UserAvatars do 

  import Ecto.Changeset
  alias MyHive.Avatarly.Generator
  require IEx

  def call(size, changeset) do
    first_name = get_change(changeset, :first_name)
    last_name = get_change(changeset, :last_name)
    if (first_name && last_name) do 
      full_name = first_name <> " " <> last_name
      has_any_avatar = get_change(changeset, :avatar_32, "")
      if has_any_avatar != "" do 
        color = Generator.avatar_color(changeset.changes.avatar_32) 
        put_change changeset, :"avatar_#{size}", generate_avatar(full_name, size, color)
      else
        put_change changeset, :avatar_32, generate_avatar(full_name, size, "random")
      end
    else
      changeset  
    end
  end  

  def generate_avatar(name, size, color) do 
    Generator.call(name, [size: size, color: color]) |> List.to_string
  end  

  
end  