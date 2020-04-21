defmodule MyHiveWeb.ContactBook.CasePersonController do
  use MyHiveWeb, :controller
  alias MyHive.ContactBook.{Address, CasePerson}
  alias MyHive.CaseManagement.MedicoLegalCase
  plug :put_root_layout, {MyHiveWeb.LayoutView, :root} when action not in [:partial]

  def partial(conn, %{"partial_view" => partial_view }) do
    render(conn, "#{partial_view}.html", changeset: generate_form_changeset())
  end

  defp generate_form_changeset() do
    MedicoLegalCase.changeset(
      %MedicoLegalCase{
        patient:
          %CasePerson{person_type: "Patient", addresses: [
            %Address{}
          ]}
       }
      )
  end

end
