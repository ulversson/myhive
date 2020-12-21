defmodule MyHive.FileManager.FileConverter do
  alias MyHive.FileManager.FileServer
  alias MyHive.Encryption.FileAssetEncryptionProcessor
  alias MyHive.Supervisors.PdfOptimizerSupervisor
  alias MyHive.FileManager.Services.{
    ImageConverter,
    VideoFileConverter,
    EmailConverter
  }

  @max_pdf_size 200

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
    calculated_size = asset.size
      |> String.to_integer
      |> Size.humanize!(output: :map)
    if calculated_size.value >= @max_pdf_size && calculated_size.symbol == "MB" && asset.encrypted == false do
       PdfOptimizerSupervisor.call(asset, "application/pdf")
    else
      encrypt_file(asset)
    end
  end

  def call(asset,_) do
    encrypt_file(asset)
  end

  defp encrypt_file(asset) do
    input_path = FileServer.call(asset)
    if File.exists?(input_path) do
      FileAssetEncryptionProcessor.call(asset)
      asset
    else
      asset
    end

  end
end
