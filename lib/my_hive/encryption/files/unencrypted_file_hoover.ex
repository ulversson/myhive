defmodule MyHive.Encryption.UnencryptedFileHoover do

  alias MyHive.FileManager.FileServer
  require Logger


  def call(asset, conn) do
    path = FileServer.call(asset)
    delay = calculated_delay(asset)
    Logger.info("Started delayed cleanup task #{delay}ms for unencrypted file")
    TaskAfter.task_after(delay, fn -> File.rm_rf(path) end)
    conn
  end

  def calculated_delay(asset) do
    size = String.to_integer(asset.size)
    file_map = Sizeable.filesize(size, output: :map)

    case file_map.unit do
      "KB" -> 10000
      "MB" -> case file_map.result do
        {1..10} -> 120000
        {10..50} -> 480000
        {50..100} -> 960000
        _ -> 1920000
      end
      "GB" ->
       case file_map.result do
        {1,2} -> 1800000
        {3,4,5} -> 3600000
        {6,7,8} -> 3600000
        _ -> 7200000
       end
    end
  end

end
