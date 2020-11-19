defmodule MyHiveWeb.PatientConsultationController do
  use MyHiveWeb, :controller
  alias MyHive.CaseManagement

  def index(conn, %{"mlc_id" => mlc_id}) do
    mlc = CaseManagement.get_medico_legal_case!(mlc_id)
    consultations = CaseManagement.consultations_for_case(mlc)
    conn |> render("consultations.json", %{
      consultations: consultations
    })
  end

  def create(conn, %{"consultation" => consultation}) do
    user = Guardian.Plug.current_resource(conn)
    mlc = CaseManagement.get_medico_legal_case!(consultation["medico_legal_case_id"])
    data = Map.merge(consultation, %{
      "user_id" => user.id,
      "patient_id" =>  mlc.patient_id
    })
    case CaseManagement.create_consultation(data) do
      {:ok, _} ->
        json(conn, %{success: true} )
      {:error, changeset} ->
        MyHiveWeb.ApiFallbackController.call(conn, {
          :error, :unauthorized
        })
    end
  end

  def update(conn, %{"id" => id, "consultation" => consultation_data}) do
    cons = CaseManagement.find_consultation_by_id(id)
    case CaseManagement.update_consultation(cons, consultation_data) do
      {:ok, _} ->
        json(conn, %{success: true} )
      {:error, changeset} ->
        MyHiveWeb.ApiFallbackController.call(conn, {
          :error, :unauthorized
        })
    end
  end

  def delete(conn, %{"id" => consultation_id}) do
    consultation_id
      |> CaseManagement.find_consultation_by_id()
      |> CaseManagement.delete_consultation()
    json(conn, %{
      "success" => true,
      "status" => "ok",
      "message" => "Removed consultation"
    } )
  end
end
