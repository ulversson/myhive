defmodule MyHiveWeb.CaseManagement.InstructingPartyView do
  use MyHiveWeb, :view

  def render("instructing_party.json", %{instructing_party: instructing_party}) do
    %{id: instructing_party.id,
      name: instructing_party.name,
      reference: instructing_party.reference}
    |> Map.put(:addresses, render_many(instructing_party.addresses, MyHiveWeb.ContactBook.AddressView, "address.json"))
  end
end
