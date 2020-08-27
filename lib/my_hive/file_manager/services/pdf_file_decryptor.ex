defmodule MyHive.FileManager.PdfFileDecryptor do

  def call(file_asset) do
    case check_encryption_command(file_asset, file_asset["filetype"]) do
      0 -> true
      2 -> false
    end
  end

  defp check_encryption_command(file_asset, content_type) when content_type == "application/pdf" do
    {"", code} = System.cmd("qpdf",["--is-encrypted", file_path(file_asset)])
    code
  end

  defp check_encryption_command(_file_asset, content_type) when content_type != "application/pdf" do
    2
  end

  defp storage_root() do
    Application.get_env(:tus, MyHiveWeb.Api.V1.UploadController)[:base_path]
  end

  defp file_path(file_asset) do
    Path.join([storage_root(), file_asset["path"]])
  end


end
