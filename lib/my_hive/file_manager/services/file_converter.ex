defmodule MyHive.FileManager.FileConverter do
  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager

  def call(asset, "message/rfc822") do
    input_path = FileServer.call(asset)
    Rambo.run(binary(), shell_cmd(input_path))
    changes = %{
      filetype: "application/pdf",
      path: "#{asset.path}.pdf",
      uid: "#{asset.uid}.pdf",
      size: to_string(File.stat!("#{input_path}.pdf").size)
    }
    FileManager.change_to_converted_asset(asset, changes)
    File.rm(input_path)
  end

  def call(_,_) do
  end

  def binary() do
    "eml_to_pdf"
  end

  def shell_cmd(input_path) do
    ["#{input_path}", "'#{input_path}.pdf'"]
  end
end
