defmodule MyHiveWeb.Plugs.MedicoLegalCaseFilterPlug do
  require IEx
  def filter_mlc(%Plug.Conn{:params => %{"medico_legal_case" => medico_legal_case}} = conn, _opts) do
    conn
    |> filter_patient_or_address(medico_legal_case)
    |> filter_claimant_address(medico_legal_case)
    |> filter_claimant(medico_legal_case)
    |> filter_instructing_party_address(medico_legal_case)
    |> filter_instructing_party(medico_legal_case)
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
      %{"patient" => %{"addresses" => %{"0" => address}} = person} = medico_legal_case
      }} = conn, _opts)  do
        case address do
          %{"address" => nil, "phone_number" => nil, "email" => nil}
          ->  {_, patient} = remove_address(person)
          medico_legal_case = Map.put(medico_legal_case, "patient", patient)
          update_mlc_params(conn, medico_legal_case)
          _ ->
          update_mlc_params(conn, medico_legal_case)
      end
  end

  defp filter_claimant_address(%Plug.Conn{:params =>
  %{"medico_legal_case" =>
      %{"claimant" => %{"addresses" => %{"0" => address}} = person} = medico_legal_case
    }} = conn, _opts)  do
      case address do
        %{"address" => nil, "phone_number" => nil, "email" => nil}
        ->  {_, claimant} = remove_address(person)
        medico_legal_case = Map.put(medico_legal_case, "claimant", claimant)
        update_mlc_params(conn, medico_legal_case)
        _ ->
        update_mlc_params(conn, medico_legal_case)
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

  defp filter_instructing_party(%Plug.Conn{:params =>
    %{"medico_legal_case" => %{"instructing_party" =>  instructing_party} = medico_legal_case }} = conn, _opts) do
      case instructing_party do
          %{"name" => nil, "contact_name" => nil}
        ->
          {_, medico_legal_case} =  Map.pop(medico_legal_case, "instructing_party")
          update_mlc_params(conn, medico_legal_case)
        _ ->
          update_mlc_params(conn, medico_legal_case)
      end
  end

  defp filter_instructing_party_address(%Plug.Conn{:params =>
  %{"medico_legal_case" =>
      %{"instructing_party" => %{"addresses" => %{"0" => address}} = person} = medico_legal_case
    }} = conn, _opts)  do
      case address do
        %{"address" => nil, "phone_number" => nil, "email" => nil}
        ->  {_, ip} = remove_address(person)
        medico_legal_case = Map.put(medico_legal_case, "instructing_party", ip)
        update_mlc_params(conn, medico_legal_case)
        _ ->
        update_mlc_params(conn, medico_legal_case)
    end
  end

  defp update_mlc_params(conn, mlc) do
    new_params = put_in(conn.params, ["medico_legal_case"], mlc)
    %Plug.Conn{conn | params: new_params}
  end

  defp remove_address(entity) do
    Map.pop(entity, "addresses")
  end
end
