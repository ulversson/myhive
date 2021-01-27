defmodule MyHive.Reports.ReportHoover do 

  alias MyHive.{
    Repo, Reports, FileManager
  } 
  alias MyHive.FileManager.FileManagerHoover

  def call(report_id, user_id) do 
    Repo.transaction(fn -> 
      report = Reports.by_id(report_id)
      file_asset = get_file_asset(report.file_asset_id)
      Enum.each(report.report_section_contents, fn section -> 
        Repo.delete(section)
      end)
      remove_asset(file_asset, user_id)
      Repo.delete(report)
    end)
  end

  defp get_file_asset(file_asset_id) when is_nil(file_asset_id) do
  end

  defp get_file_asset(file_asset_id) when is_binary(file_asset_id) do
    FileManager.get_file_asset!(file_asset_id)
  end

  defp remove_asset(file_asset, _) when is_nil(file_asset) do 
  end

  defp remove_asset(file_asset, user_id) when is_map(file_asset) do 
    FileManagerHoover.soft_delete_item(file_asset, user_id)
  end

end