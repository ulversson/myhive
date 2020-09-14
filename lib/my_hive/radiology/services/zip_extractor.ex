defmodule MyHive.Radiology.ZipExtractor do
  alias MyHive.WalkDirectory

  def call(input_path, output_path) do
    case :zip.unzip(input_path, [{:cwd, output_path}]) do
      {:ok, content} ->
        if (WalkDirectory.exists?(output_path, "DICOMDIR")) do
          {:ok, content}
        else
          {:error, :not_dicom}
        end
      {:error, error} -> {:error, error}
    end
  end

end
