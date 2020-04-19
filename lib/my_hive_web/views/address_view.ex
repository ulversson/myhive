defmodule MyHiveWeb.AddressView do
  use MyHiveWeb, :view
  alias MyHiveWeb.AddressView

  def render("index.json", %{addresses: addresses}) do
    %{data: render_many(addresses, AddressView, "address.json")}
  end

  def render("show.json", %{address: address}) do
    %{data: render_one(address, AddressView, "address.json")}
  end

  def render("address.json", %{address: address}) do
    %{id: address.id,
      address_line1: address.address_line1,
      address_line2: address.address_line2,
      address_line3: address.address_line3,
      addressable_id: address.addressable_id,
      addressable_type: address.addressable_type,
      phone_number: address.phone_number,
      email: address.email,
      name: address.name}
  end
end
