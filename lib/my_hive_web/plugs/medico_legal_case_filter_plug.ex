defmodule MyHiveWeb.Plugs.MedicoLegalCaseFilterPlug do

  def filter_mlc(%Plug.Conn{:params => %{"medico_legal_case" => medico_legal_case}} = conn, _opts) do
    conn
    |> filter_patient_or_address(medico_legal_case)
    |> filter_claimant(medico_legal_case)
  end

  defp filter_patient_or_address(%Plug.Conn{:params =>
    %{"medico_legal_case" => %{"patient_id" => _} = mlc}} = conn, _opts) do
    {_, mlc} =  Map.pop(mlc, "patient")
    update_mlc_params(conn, mlc)
  end

  defp filter_patient_or_address(%Plug.Conn{:params =>
    %{"medico_legal_case" => %{"patient" => %{"deceased" => _} = patient}= mlc}} = conn, _opts)  when map_size(patient) == 1 do
      {_, mlc} =  Map.pop(mlc, "patient")
      Map.put(mlc, "patient_id", nil)
      update_mlc_params(conn, mlc)
  end

  defp filter_patient_or_address(%Plug.Conn{:params =>
    %{"medico_legal_case" =>
      %{"patient" => %{"addresses" => %{"0" => _address}} = _person} = medico_legal_case
      }} = conn, _opts)  do
        update_mlc_params(conn, medico_legal_case)
  end

  defp filter_claimant(%Plug.Conn{:params => %{"medico_legal_case" => %{"patient" => patient} = medico_legal_case }} = conn, _opts) do
      case patient do
      %{"deceased" => "false"} ->
        {_, medico_legal_case} =  Map.pop(medico_legal_case, "claimant")
        update_mlc_params(conn, medico_legal_case)
      _ -> update_mlc_params(conn, medico_legal_case)
      end
  end

    defp filter_claimant(%Plug.Conn{:params =>
    %{"medico_legal_case" => %{"claimant" =>  claimant} = medico_legal_case }} = conn, _opts) do
        case claimant do
          %{"first_name" => nil, "last_name" => nil}
        ->
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
