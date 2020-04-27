defmodule MyHiveWeb.ContactBook.AddressView do
  use MyHiveWeb, :view

  def render("address.json", %{address: address}) do
    %{id: address.id,
      address: address.address,
      phone_number: address.phone_number,
      email: address.email,
      name: address.name}
  end

end
