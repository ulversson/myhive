defmodule MyHive.FileManager.FileUrlDownloader do

  def call(url, save_to_path) do
    :inets.start()
    :ssl.start()

    {:ok, :saved_to_file} = :httpc.request(:get, {
      String.to_charlist(url), []
    }, [], [stream: String.to_charlist(save_to_path)])
  end
end
