defmodule MyHive.FileManager.FileConverter do
  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager

  def call(asset, "message/rfc822") do
    input_path = FileServer.call(asset)
    System.cmd("bundle", shell_cmd(input_path))
    changes = %{
      filetype: "application/pdf",
      path: "#{asset.path}.pdf",
      uid: "#{asset.uid}.pdf",
      size: File.stat!("#{input_path}.pdf").size
    }
    FileManager.change_to_converted_asset(asset, changes)
    File.rm(input_path)
  end

  def call(_,_) do
  end

  defp shell_cmd(input_path) do
    ["exec", "eml_to_pdf", input_path, "#{input_path}.pdf"]
  end
end
