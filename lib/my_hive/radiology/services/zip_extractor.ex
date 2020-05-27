defmodule MyHive.Radiology.ZipExtractor do

  def call(input_path, output_path) do
    case :zip.unzip(input_path, [{:cwd, output_path}]) do
      {:ok, content} ->
        dicomdir = Path.join(output_path, "DICOMDIR")
        if (File.exists?(dicomdir)) do
          {:ok, content}
        else
          {:error, :not_dicom}
        end
      {:error, error} -> {:error, error}
    end
  end

end
