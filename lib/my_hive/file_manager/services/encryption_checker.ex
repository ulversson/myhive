defmodule MyHive.FileManager.EncryptionChecker do

  def call(file_asset, content_type) when content_type == "application/pdf" do
    case check_encryption_command(file_asset, file_asset["filetype"]) do
      0 -> true
      2 -> false
    end
  end

  def call(file_asset, content_type) when content_type == "application/pdf" do
    case check_encryption_command(file_asset, file_asset["filetype"]) do
      0 -> true
      2 -> false
    end
  end

  def call(file_asset, content_type) when content_type == "application/vnd.openxmlformats-officedocument.wordprocessingml.document" do
    case check_encryption_command(file_asset, file_asset["filetype"]) do
      0 -> true
      1 -> false
    end
  end

  def call(_file_asset, content_type) when content_type != "application/vnd.openxmlformats-officedocument.wordprocessingml.document" and content_type != "application/pdf" do
    false
  end

  defp check_encryption_command(file_asset, content_type) when content_type == "application/pdf" do
    {"", code} = System.cmd("qpdf",["--is-encrypted", file_path(file_asset)])
    code
  end

  defp check_encryption_command(file_asset, content_type) when content_type == "application/vnd.openxmlformats-officedocument.wordprocessingml.document" do
    {"", code} = System.cmd("msoffcrypto-tool",[file_path(file_asset), "-t"])
    code
  end

  defp storage_root() do
    Application.get_env(:tus, MyHiveWeb.Api.V1.UploadController)[:base_path]
  end

  defp file_path(file_asset) do
    Path.join([storage_root(), file_asset["path"]])
  end


end
