defmodule MyHive.Radiology.Services.OrthancClient do
  import MyHive.Radiology.RadiologyConfig
  import MyHive.Utils.MapUtils
  import MyHive.Radiology.Services.DicomTagDictionary

  def call(patient, offset \\ 0) do
    url = request_url(patient, offset)
    case HTTPoison.get(url) do
      {:error, err} -> err
      {:ok, resp} ->
        series = Jason.decode(resp.body) |> elem(1)
        Enum.map(series, fn map ->
          Enum.map(map, fn s_map = {k, val} ->
            tag = find_tag(k)
            unless is_nil(tag) do
              replace_keys(Map.new([s_map]), [{k, tag}])
            else
              s_map
            end
          end)
        end)
    end
  end

  def simplify(response) do
    response
    |> Enum.map(fn m ->
      Enum.map(m, fn item ->
        for {k, v} <- item, into: %{} do
          {k, v["Value"] |> List.first}
        end
      end)
      |> merge_maps()
   end)
  end

  defp find_tag(tag) do
    all_tags()
      |> Enum.filter(fn m ->
         Enum.member?(Tuple.to_list(m), tag)
      end)
      |> List.first()
      |> elem(1)
  end

  defp request_url(patient, offset \\ 0) do
    base_uri() <> path(patient, offset)
  end

  defp base_uri() do
    "https://#{username()}:#{password()}@#{browser()}"
  end

  defp path(patient, offset \\ 0) do
    "/orthanc/dicom-web/studies?PatientName=#{patient}&limit=100&offset=#{offset}&fuzzymatching=false&includefield=all"
  end

end

#
