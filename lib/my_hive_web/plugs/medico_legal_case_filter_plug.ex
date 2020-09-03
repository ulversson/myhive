defmodule MyHiveWeb.Plugs.MedicoLegalCaseFilterPlug do

  def filter_mlc(%Plug.Conn{:params => %{"medico_legal_case" => medico_legal_case}} = conn, _opts) do
    conn
    |> filter_claimant(medico_legal_case)
  end

  defp filter_claimant(%Plug.Conn{:params =>
    %{"medico_legal_case" => %{"patient" => patient} = medico_legal_case }} = conn, _opts) do
        case patient do
        %{"deceased" => "false"} ->
          {_, medico_legal_case} =  Map.pop(medico_legal_case, "claimant")
          update_mlc_params(conn, medico_legal_case)
        _ ->
        update_mlc_params(conn, medico_legal_case)
    end
  end

  defp update_mlc_params(conn, mlc) do
    new_params = put_in(conn.params, ["medico_legal_case"], mlc)
    %Plug.Conn{conn | params: new_params}
  end
end
