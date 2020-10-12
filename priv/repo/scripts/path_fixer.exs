alias MyHive.{Repo, FileManager}
alias MyHive.FileManager.FileAsset
import Ecto.Query, warn: false

all_assets = Repo.all(FileAsset)
to_fix = Enum.filter(all_assets, fn file ->
  String.starts_with?(file.path, "/storage")
end)
Enum.each(to_fix, fn file_to_fix ->
  FileManager.update_file_asset(file_to_fix, %{
    path: String.replace(file_to_fix.path, "/storage/files/","")
  })
end)
