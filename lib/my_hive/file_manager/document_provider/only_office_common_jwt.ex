defmodule MyHive.FileManager.OnlyOfficeCommonJwt do

  defp env do
    Application.get_env(:my_hive, :environment)
  end

  def path_to_rubyfile(file \\ "json_to_jwt.rb") do
    if env() == :dev do
      Path.join([File.cwd!, "lib", "my_hive", "file_manager", "document_provider", file])
    else
      Path.join([File.cwd!, file])
    end
  end
end
