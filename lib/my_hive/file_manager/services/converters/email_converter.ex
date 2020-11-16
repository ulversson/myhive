defmodule MyHive.FileManager.Services.EmailConverter do

  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager
  alias MyHive.Encryption.FileAssetEncryptionProcessor

  def call(asset, "message/rfc822") do
    input_path = FileServer.call(asset)
    Rambo.run(eml_to_pdf_binary(), eml_to_pdf_shell_cmd(input_path))
    changes = %{
      filetype: "application/pdf",
      path: "#{asset.path}.pdf",
      uid: "#{asset.uid}.pdf",
      size: to_string(File.stat!("#{input_path}.pdf").size)
    }
    FileManager.change_to_converted_asset(asset, changes)
    FileAssetEncryptionProcessor.call(asset)
    File.rm(input_path)
    asset
  end

  defp eml_to_pdf_binary() do
    "eml_to_pdf"
  end

  defp eml_to_pdf_shell_cmd(input_path) do
    ["#{input_path}", "'#{input_path}.pdf'"]
  end

end
