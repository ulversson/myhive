defmodule MyHive.FileManager.FolderTypeResolver do

  def icon(type) do
    case type do
      "medico_legal_case" -> "fas fa-folder"
      "medico_legal_case_root" -> "fas fa-folder"
      "medico_legal_case_admin" -> "fas fa-user-lock"
      "medico_legal_case_correspondence" -> "fas fa-mail-bulk"
      "archive" -> "far fa-folder"
      "shared_folder" -> "icmn-folder-upload"
      "medico_legal_case_consultation" -> "fas fa-briefcase"
    end
  end

end
