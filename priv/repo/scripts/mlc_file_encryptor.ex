alias MyHive.CaseManagement.MedicoLegalCase
alias MyHive.{CaseManagement, FileManager}
alias MyHive.FileManager.{Folder, FileAsset}
alias MyHive.Repo
import Ecto.Query, warn: false
alias MyHive.Encryption.FileAssetEncryptionProcessor
#for i <- 0..20, do:
mlc_id = 11

mlc = CaseManagement.get_medico_legal_case!(mlc_id)
folder = FileManager.get_folder!(mlc.folder_id)
descendants = Folder.descendants(folder) |> Repo.all

folders_ids = Enum.map(descendants, fn folder ->
  folder.id
end)

query = from fa in FileAsset,
where: fa.folder_id in ^folders_ids

file_assets = Repo.all(query)
Enum.each(all, fn file_asset ->
  FileAssetEncryptionProcessor.call(file_asset)
end)


all = Repo.all(FileAsset)
emls = Enum.filter(all, fn fa -> String.ends_with?(fa.name, ".eml") end)
