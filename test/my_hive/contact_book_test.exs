defmodule MyHive.ContactBookTest do
  use MyHive.DataCase

  alias MyHive.ContactBook

  describe "addresses" do
    alias MyHive.ContactBook.Address

    @valid_attrs %{address_line1: "some address_line1", address_line2: "some address_line2", address_line3: "some address_line3", addressable_id: 42, addressable_type: "some addressable_type", email: "some email", name: "some name", phone_number: "some phone_number"}
    @update_attrs %{address_line1: "some updated address_line1", address_line2: "some updated address_line2", address_line3: "some updated address_line3", addressable_id: 43, addressable_type: "some updated addressable_type", email: "some updated email", name: "some updated name", phone_number: "some updated phone_number"}
    @invalid_attrs %{address_line1: nil, address_line2: nil, address_line3: nil, addressable_id: nil, addressable_type: nil, email: nil, name: nil, phone_number: nil}

    def address_fixture(attrs \\ %{}) do
      {:ok, address} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ContactBook.create_address()

      address
    end

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert ContactBook.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert ContactBook.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      assert {:ok, %Address{} = address} = ContactBook.create_address(@valid_attrs)
      assert address.address_line1 == "some address_line1"
      assert address.address_line2 == "some address_line2"
      assert address.address_line3 == "some address_line3"
      assert address.addressable_id == 42
      assert address.addressable_type == "some addressable_type"
      assert address.email == "some email"
      assert address.name == "some name"
      assert address.phone_number == "some phone_number"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContactBook.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      assert {:ok, %Address{} = address} = ContactBook.update_address(address, @update_attrs)
      assert address.address_line1 == "some updated address_line1"
      assert address.address_line2 == "some updated address_line2"
      assert address.address_line3 == "some updated address_line3"
      assert address.addressable_id == 43
      assert address.addressable_type == "some updated addressable_type"
      assert address.email == "some updated email"
      assert address.name == "some updated name"
      assert address.phone_number == "some updated phone_number"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = ContactBook.update_address(address, @invalid_attrs)
      assert address == ContactBook.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = ContactBook.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> ContactBook.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = ContactBook.change_address(address)
    end
  end

  describe "people" do
    alias MyHive.ContactBook.CasePerson

    @valid_attrs %{address_id: 42, date_of_birth: ~D[2010-04-17], date_of_death: ~D[2010-04-17], first_name: "some first_name", last_name: "some last_name", person_type: "some person_type"}
    @update_attrs %{address_id: 43, date_of_birth: ~D[2011-05-18], date_of_death: ~D[2011-05-18], first_name: "some updated first_name", last_name: "some updated last_name", person_type: "some updated person_type"}
    @invalid_attrs %{address_id: nil, date_of_birth: nil, date_of_death: nil, first_name: nil, last_name: nil, person_type: nil}

    def case_person_fixture(attrs \\ %{}) do
      {:ok, case_person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ContactBook.create_case_person()

      case_person
    end

    test "list_people/0 returns all people" do
      case_person = case_person_fixture()
      assert ContactBook.list_people() == [case_person]
    end

    test "get_case_person!/1 returns the case_person with given id" do
      case_person = case_person_fixture()
      assert ContactBook.get_case_person!(case_person.id) == case_person
    end

    test "create_case_person/1 with valid data creates a case_person" do
      assert {:ok, %CasePerson{} = case_person} = ContactBook.create_case_person(@valid_attrs)
      assert case_person.address_id == 42
      assert case_person.date_of_birth == ~D[2010-04-17]
      assert case_person.date_of_death == ~D[2010-04-17]
      assert case_person.first_name == "some first_name"
      assert case_person.last_name == "some last_name"
      assert case_person.person_type == "some person_type"
    end

    test "create_case_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContactBook.create_case_person(@invalid_attrs)
    end

    test "update_case_person/2 with valid data updates the case_person" do
      case_person = case_person_fixture()
      assert {:ok, %CasePerson{} = case_person} = ContactBook.update_case_person(case_person, @update_attrs)
      assert case_person.address_id == 43
      assert case_person.date_of_birth == ~D[2011-05-18]
      assert case_person.date_of_death == ~D[2011-05-18]
      assert case_person.first_name == "some updated first_name"
      assert case_person.last_name == "some updated last_name"
      assert case_person.person_type == "some updated person_type"
    end

    test "update_case_person/2 with invalid data returns error changeset" do
      case_person = case_person_fixture()
      assert {:error, %Ecto.Changeset{}} = ContactBook.update_case_person(case_person, @invalid_attrs)
      assert case_person == ContactBook.get_case_person!(case_person.id)
    end

    test "delete_case_person/1 deletes the case_person" do
      case_person = case_person_fixture()
      assert {:ok, %CasePerson{}} = ContactBook.delete_case_person(case_person)
      assert_raise Ecto.NoResultsError, fn -> ContactBook.get_case_person!(case_person.id) end
    end

    test "change_case_person/1 returns a case_person changeset" do
      case_person = case_person_fixture()
      assert %Ecto.Changeset{} = ContactBook.change_case_person(case_person)
    end
  end
end
