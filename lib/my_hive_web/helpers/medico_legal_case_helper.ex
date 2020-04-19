defmodule MyHiveWeb.Helpers.MedicoLegalCaseHelper do
  def filter_mlc(%Plug.Conn{:params => %{"medico_legal_case" => medico_legal_case}} = conn, _opts) do
    conn
    |> filter_address(medico_legal_case)
    |> filter_claimant_address(medico_legal_case)
    |> filter_claimant(medico_legal_case)
    |> filter_instructing_party_address(medico_legal_case)
    |> filter_instructing_party(medico_legal_case)
  end


  defp filter_address(%Plug.Conn{:params =>
    %{"medico_legal_case" =>
      %{"patient" => %{"addresses" => %{"0" => address}} = person} = medico_legal_case
      }} = conn, _opts)  do
        case address do
          %{"address" => nil, "phone_number" => nil, "email" => nil}
          ->  {_, patient} = Map.pop(person, "addresses")
          medico_legal_case = Map.put(medico_legal_case, "patient", patient)
              new_params = put_in(conn.params, ["medico_legal_case"], medico_legal_case)
              %Plug.Conn{conn | params: new_params}
          _ ->
            new_params = put_in(conn.params, ["medico_legal_case"], medico_legal_case)
            %Plug.Conn{conn | params: new_params}
      end
  end

  defp filter_claimant_address(%Plug.Conn{:params =>
  %{"medico_legal_case" =>
      %{"claimant" => %{"addresses" => %{"0" => address}} = person} = medico_legal_case
    }} = conn, _opts)  do
      case address do
        %{"address" => nil, "phone_number" => nil, "email" => nil}
        ->  {_, claimant} = Map.pop(person, "addresses")
        medico_legal_case = Map.put(medico_legal_case, "claimant", claimant)

        new_params = put_in(conn.params, ["medico_legal_case"], medico_legal_case)
        %Plug.Conn{conn | params: new_params}
        _ ->
          new_params = put_in(conn.params, ["medico_legal_case"], medico_legal_case)
          %Plug.Conn{conn | params: new_params}
    end
  end

  defp filter_claimant(%Plug.Conn{:params =>
    %{"medico_legal_case" => %{"claimant" =>  claimant} = medico_legal_case }} = conn, _opts) do
        case claimant do
          %{"first_name" => nil, "last_name" => nil}
        ->
          {_, medico_legal_case} =  Map.pop(medico_legal_case, "claimant")
          new_params = put_in(conn.params, ["medico_legal_case"], medico_legal_case)
          %Plug.Conn{conn | params: new_params}
        _ ->
        new_params = put_in(conn.params, ["medico_legal_case"], medico_legal_case)
        %Plug.Conn{conn | params: new_params}
    end
  end

  defp filter_instructing_party(%Plug.Conn{:params =>
    %{"medico_legal_case" => %{"instructing_party" =>  instructing_party} = medico_legal_case }} = conn, _opts) do
      case instructing_party do
          %{"name" => nil, "contact_name" => nil}
        ->
          {_, medico_legal_case} =  Map.pop(medico_legal_case, "instructing_party")
          new_params = put_in(conn.params, ["medico_legal_case"], medico_legal_case)
          %Plug.Conn{conn | params: new_params}
        _ ->
          new_params = put_in(conn.params, ["medico_legal_case"], medico_legal_case)
          %Plug.Conn{conn | params: new_params}
      end
  end

  defp filter_instructing_party_address(%Plug.Conn{:params =>
  %{"medico_legal_case" =>
      %{"instructing_party" => %{"addresses" => %{"0" => address}} = person} = medico_legal_case
    }} = conn, _opts)  do
      case address do
        %{"address" => nil, "phone_number" => nil, "email" => nil}
        ->  {_, ip} = Map.pop(person, "addresses")
        medico_legal_case = Map.put(medico_legal_case, "instructing_party", ip)

        new_params = put_in(conn.params, ["medico_legal_case"], medico_legal_case)

        %Plug.Conn{conn | params: new_params}
        _ ->
          new_params = put_in(conn.params, ["medico_legal_case"], medico_legal_case)
          %Plug.Conn{conn | params: new_params}
    end
  end


end
