defmodule MyHiveWeb.ContactBook.CasePersonView do
  use MyHiveWeb, :view
  require IEx
  def render("case_person.json", %{case_person: case_person}) do
    p = %{id: case_person.id,
      first_name: case_person.first_name,
      last_name: case_person.last_name,
      date_of_birth: case_person.date_of_birth,
      date_of_death: case_person.date_of_death,
      deceased: case_person.deceased
    }
    Map.put(p, :addresses, render_many(case_person.addresses,
      MyHiveWeb.ContactBook.AddressView, "address.json", as: :address))
  end
end
