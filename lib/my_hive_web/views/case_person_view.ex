defmodule MyHiveWeb.CasePersonView do
  use MyHiveWeb, :view
  alias MyHiveWeb.CasePersonView

  def render("index.json", %{people: people}) do
    %{data: render_many(people, CasePersonView, "case_person.json")}
  end

  def render("show.json", %{case_person: case_person}) do
    %{data: render_one(case_person, CasePersonView, "case_person.json")}
  end

  def render("case_person.json", %{case_person: case_person}) do
    %{id: case_person.id,
      person_type: case_person.person_type,
      first_name: case_person.first_name,
      last_name: case_person.last_name,
      address_id: case_person.address_id,
      date_of_birth: case_person.date_of_birth,
      date_of_death: case_person.date_of_death}
  end
end
