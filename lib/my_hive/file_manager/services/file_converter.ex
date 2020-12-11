defmodule MyHive.FileManager.FileConverter do
  alias MyHive.FileManager.FileServer
  alias MyHive.Encryption.FileAssetEncryptionProcessor
  alias MyHive.Supervisors.PdfOptimizerSupervisor
  alias MyHive.FileManager.Services.{
    ImageConverter,
    VideoFileConverter,
    EmailConverter
  }

  def call(asset, "image/heic") do
    ImageConverter.call(asset, "image/heic")
  end

  def call(asset, "image/heif") do
    ImageConverter.call(asset, "image/heif")
  end

  def call(asset, "video/quicktime") do
    VideoFileConverter.call(asset, "video/quicktime")
  end

  def call(asset, "video/mp4") do
    VideoFileConverter.call(asset, "video/mp4")
  end

  def call(asset, "message/rfc822") do
    EmailConverter.call(asset, "message/rfc822")
  end

  def call(asset, "application/zip") do
    asset #encrypt later
  end

  def call(asset, "application/pdf") do
    PdfOptimizerSupervisor.call(asset, "application/pdf")
    asset
  end

  def call(asset,_) do
    input_path = FileServer.call(asset)
    if File.exists?(input_path) do
      FileAssetEncryptionProcessor.call(asset)
    end
    asset
  end
end
