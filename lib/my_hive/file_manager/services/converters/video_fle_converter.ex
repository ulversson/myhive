defmodule MyHive.FileManager.Services.VideoFileConverter do

  alias MyHive.FileManager.FileServer
  alias MyHive.FileManager
  alias MyHive.FileManager.FileAssetVideoCodecGuesser
  alias MyHive.Encryption.FileAssetEncryptionProcessor
  import MyHive.FileManager.Services.ConvertersCommon

  def call(asset, "video/quicktime") do
    input_path = FileServer.call(asset)
    FileManager.update_file_asset(asset, %{name: "...converting...please wait..."})
    convert_and_update_database(asset, input_path)
  end

  def call(asset, "video/mp4") do
    input_path = FileServer.call(asset)
    if FileAssetVideoCodecGuesser.call(input_path) != "h264" do
      FileManager.update_file_asset(asset, %{name: "...converting...please wait..."})
      convert_and_update_database(asset, input_path)
    else
      FileAssetEncryptionProcessor.call(asset)
      File.rm(input_path)
      asset
    end
  end

  def convert_and_update_database(asset, input_path) do
    TaskAfter.task_after(500, fn ->
      Rambo.run(ffmpeg_binary(), mp4_convert_params(input_path))
      changes = %{
        filetype: "video/mp4",
        path: relative_path(input_path),
        name: mp4_name(asset),
        uid: "#{asset.uid}",
        size: to_string(File.stat!(mp4_output_path(input_path)).size)
      }
      {:ok, asset} = FileManager.change_to_converted_asset(asset, changes)
      FileAssetEncryptionProcessor.call(asset)
      File.rm_rf(input_path)
      asset
    end, send_result: self())
    asset
  end

  defp ffmpeg_binary() do
    "ffmpeg"
  end

  defp mp4_convert_params(input_path) do
    ["-i", input_path, "-vcodec", "h264", "-y", "-acodec", "mp2",  mp4_output_path(input_path)]
  end

  defp mp4_output_path(input_path) do
    input_path
      |> String.replace("MOV", "mp4")
      |> String.replace("mov", "mp4")
      |> String.replace(".mp4", "_converted.mp4")
  end

  defp mp4_name(asset) do
    out = asset.name
     |> String.replace("MOV", "mp4")
     |> String.replace("mov", "mp4")
     "converted_#{out}"
  end

  def relative_path(input_path) do
    path = mp4_output_path(input_path)
    String.replace(path, File.cwd!, "")
      |> String.replace(storage_root(), "")
      |> String.replace("//","")
   end

end
