defmodule MyHive.FileManager.Services.PdfSizeOptimizer do

  alias MyHive.FileManager
  alias MyHive.Encryption.FileAssetEncryptionProcessor
  alias MyHive.FileManager.{
    FileMetadataReader,
    FileTypeResolver,
    FileServer
  }
  import MyHive.FileManager.Services.ConvertersCommon

  @max_pdf_size 200

  def call(asset, "application/pdf")  do
    input_path = FileServer.call(asset)
    calculated_size = asset.size
      |> String.to_integer
      |> Size.humanize!(output: :map)
    optimize_size(asset, calculated_size.value)
  end

  defp optimize_size(asset, pdf_size) when pdf_size >= @max_pdf_size do
    input_path = FileServer.call(asset)
    opts = optimize_command(input_path, pdf_output_path(input_path))
      |> String.split(" ")
    Rambo.run("gs", opts)
    changes = %{
      filetype: "application/pdf",
      path:  relative_path(input_path),
      uid: asset.uid,
      name: asset.name,
      size: to_string(File.stat!(pdf_output_path(input_path)).size)
    }
    {:ok, asset} = FileManager.change_to_converted_asset(asset, changes)
    FileAssetEncryptionProcessor.call(asset)
    File.rm(input_path)
    asset
  end

  defp optimize_size(asset, pdf_size) when pdf_size < @max_pdf_size do
    asset
  end

  defp pdf_output_path(input_path) do
    input_path
      |> String.replace(".pdf", "_optimized.pdf")
  end

  defp optimize_command(input_pdf, output_pdf) do
    "-q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dEmbedAllFonts=true -dSubsetFonts=true -dColorImageDownsampleType=/Bicubic -dColorImageResolution=144 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=144 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=144 -sOutputFile=#{output_pdf} #{input_pdf}"
  end

  defp relative_path(input_path) do
    path = pdf_output_path(input_path)
    new_path = String.replace(path, File.cwd!, "")
      |> String.replace(storage_root(), "")
      |> String.replace("//","")
      if String.starts_with?(new_path, "/") do
        String.slice(new_path, 1..-1)
      else
        new_path
      end
  end

end
