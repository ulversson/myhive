defmodule MyHive.FileManager.FolderTypeResolver do

  def icon(type) do
    case type do
      "medico_legal_case" -> "icmn-folder"
      "medico_legal_case_root" -> "icmn-folder"
      "medico_legal_case_admin" -> "fas fa-user-lock"
      "medico_legal_case_correspondence" -> "fas fa-mail-bulk"
    end
  end

end
