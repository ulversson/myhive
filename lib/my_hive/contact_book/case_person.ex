defmodule MyHive.ContactBook.CasePerson do
  use Ecto.Schema
  import Ecto.Changeset
  schema "people" do
    field :date_of_birth, :date
    field :date_of_death, :date
    field :first_name, :string
    field :last_name, :string
    field :person_type, :string
    field :deceased, :boolean, default: false
    has_many :addresses, MyHive.ContactBook.Address,
      foreign_key: :addressable_id, on_replace: :delete
    timestamps()
  end


  def age(person) do
    if person.date_of_birth do
      Timex.diff(Timex.today, person.date_of_birth, :years)
    else
      nil
    end
  end
  @doc false
  def changeset(case_person, attrs) do
    case_person
    |> cast(attrs, [:person_type, :deceased, :first_name, :last_name, :date_of_birth, :date_of_death])
    |> cast_assoc(:addresses, required: false)
    |> optionally_validate_dob()
    |> update_change(:first_name, &String.trim/1)
    |> update_change(:last_name, &String.trim/1)
    |> validate_required([:person_type, :first_name, :last_name], message: "cannot be blank")
  end

  defp optionally_validate_dob(changeset) do
    case get_field(changeset, :person_type) do
      "Patient" ->
        dob = get_field(changeset, :date_of_birth)
        if is_nil(dob) do
          add_error(changeset, :date_of_birth, "cannot be blank")
        else
          changeset
        end
      _   -> changeset
    end
  end


end
