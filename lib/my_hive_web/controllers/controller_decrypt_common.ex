defmodule MyHiveWeb.ControllerDecryptCommon do

  alias MyHive.Encryption.{
    FileAssetDecryptionProcessor,
    UnencryptedFileHoover
  }

  def delayed_remove(conn, asset, true) do
    Plug.Conn.register_before_send(conn, fn conn ->
      UnencryptedFileHoover.call(asset, conn)
    end)
  end

  def delayed_remove(conn, _asset, false) do
    conn
  end

  def decrypt_asset(asset, true) do
    FileAssetDecryptionProcessor.call(asset)
  end

  def decrypt_asset(_asset, false) do
  end

end
