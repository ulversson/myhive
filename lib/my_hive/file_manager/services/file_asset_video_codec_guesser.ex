#ffprobe -loglevel error -select_streams v -show_entries stream=codec_name -of default=nw=1:nk=1 input.mkv
defmodule MyHive.FileManager.FileAssetVideoCodecGuesser do

  def call(input_file_path) do
    case run_command(input_file_path) do
      {:ok, rambo_result} -> String.trim(rambo_result.out)
      {:error, _} -> false
    end
  end

  def run_command(input_file_path) do
    Rambo.run("ffprobe", [
      "-loglevel", "error", "-select_streams", "v",
      "-show_entries", "stream=codec_name", "-of",
      "default=nw=1:nk=1", input_file_path
    ])
  end

end
