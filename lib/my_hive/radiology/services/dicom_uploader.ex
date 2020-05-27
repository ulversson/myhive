defmodule MyHive.Radiology.DicomUploader do
  @uploader "bin/UploadImages.py"
  def call(dicom_path) do
    call_uploader(dicom_path)
  end

  defp call_uploader(dicom_path) do
    if username?() && password?() do
      {:ok, %Rambo{status: _, out: out, err: err}} =
      Rambo.run("python3", [
        uploader_path(),
        radiology_config()[:host],
        dicom_port(),
        dicom_path,
      ])
      if err != "" do
        {:error, err}
      else
        {:ok, out}
      end
    else
      {:ok, %Rambo{status: _, out: out, err: err}} =
      Rambo.run("python3", [
        uploader_path(),
        radiology_config()[:host],
        dicom_port(),
        dicom_path,
        radiology_config()[:username],
        radiology_config()[:password]
      ])
      if err != "" do
        {:error, err}
      else
        {:ok, out}
      end
    end
  end

  defp uploader_path() do
    Path.expand(@uploader)
  end

  defp username? do
    radiology_config()[:username] != ""
  end

  defp password? do
    radiology_config()[:password] != ""
  end

  defp dicom_port do
    radiology_config()[:port] |> to_string
  end

  defp radiology_config() do
    Application.get_env(:my_hive, MyHiveWeb.Endpoint)[:radiology]
  end

end
