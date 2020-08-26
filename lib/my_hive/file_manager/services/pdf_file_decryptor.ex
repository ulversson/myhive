defmodule MyHive.FileManager.PdfFileDecryptor do

  alias MyHive.FileManager.FileServer

  def call(file_asset) do
    case check_encryption_command(file_asset) do
      0 -> true
      2 -> false
    end
  end

  defp check_encryption_command(file_asset) do
    {:ok, code} = System.cmd("qpdf",["--is-encrypted", FileServer.call(file_asset)])
    code
  end

end
