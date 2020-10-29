defmodule MyHive.FileManager.FileConverter do
  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager

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
    File.rm(input_path)
  end

  def call(asset, "video/quicktime") do
    input_path = FileServer.call(asset)
    Rambo.run(ffmpeg_binary(), mp4_convert_params(input_path))
    changes = %{
      filetype: "video/mp4",
      path: mp4_output_path(input_path),
      name: mp4_name(asset),
      uid: "#{asset.uid}",
      size: to_string(File.stat!(mp4_output_path(input_path)).size)
    }
    FileManager.change_to_converted_asset(asset, changes)
    File.rm(input_path)
  end

  def call(_,_) do
  end

  defp ffmpeg_binary() do
    "ffmpeg"
  end

  defp eml_to_pdf_binary() do
    "eml_to_pdf"
  end

  defp eml_to_pdf_shell_cmd(input_path) do
    ["#{input_path}", "'#{input_path}.pdf'"]
  end

  defp mp4_convert_params(input_path) do
      #ffmpeg -i my-video.mov -vcodec h264 -acodec mp2 my-video.mp4
    ["-i", input_path, "-vcodec", "h264", "-acodec", "mp2",  mp4_output_path(input_path)]
  end

  defp mp4_output_path(input_path) do
    input_path
      |> String.replace("MOV", "mp4")
      |> String.replace("mov", "mp4")
  end

  defp mp4_name(asset) do
    asset.name
     |> String.replace("MOV", "mp4")
     |> String.replace("mov", "mp4")
  end
end
