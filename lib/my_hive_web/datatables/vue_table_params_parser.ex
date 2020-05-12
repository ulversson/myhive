defmodule MyHiveWeb.Datatables.VueTableParamsParser do

  def build_paging_info(params) do
    page_size = calculate_page_size(params["limit"])
    page_number = String.to_integer(params["page"])
    search_term = params["query"]
    draw_number = increment_draw(params["limit"])
    {page_size, page_number, search_term, draw_number}
  end

  defp increment_draw(value) when value == nil, do: 1

  defp increment_draw(value) do
    {draw_number, _} = Integer.parse(value)
    draw_number + 1
  end

  defp calculate_page_size(nil), do: 10

  defp calculate_page_size(value) do
    {page_size, _} = Integer.parse(value)
    page_size
  end


end
