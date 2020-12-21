alias MyHive.EmailTemplates
alias MyHive.Repo
alias MyHive.EmailTemplates.{
  TemplateVariable
}
EmailTemplates.get_variable_by_code("recipient_name")
  |> TemplateVariable.changeset(%{name: "Recipient name"})
  |> Repo.update
EmailTemplates.get_variable_by_code("expert_name")
  |> TemplateVariable.changeset(%{name: "Expert's name"})
  |> Repo.update
EmailTemplates.get_variable_by_code("expert_discipline")
  |> TemplateVariable.changeset(%{name: "Expert's discipline"})
  |> Repo.update
EmailTemplates.get_variable_by_code("free_text")
  |> TemplateVariable.changeset(%{name: "Free text"})
  |> Repo.update
EmailTemplates.get_variable_by_code("hourly_rate")
  |> TemplateVariable.changeset(%{name: "Hourly rate"})
  |> Repo.update
EmailTemplates.get_variable_by_code("free_text_one_line")
  |> TemplateVariable.changeset(%{name: "Free text"})
  |> Repo.update
other_variables = [
  %{
    name: "Claimant's name", code: "claimant_name",
    input_type: "mlc",
    description: "Claimant's name"
  },
  %{
    name: "Instructing party's name", code: "instructing_party_name",
    input_type: "mlc",
    description: "Instructing party's name"
  },
  %{
    name: "Invoice number", code: "invoice_number", input_type: "text",
    description: "Invoice number"
  },
  %{
    name: "Invoice amount", code: "invoice_amount", input_type: "number",
    description: "Invoice number"
  },
  %{
    name: "Time", code: "time", input_type: "time",
    description: "Time"
  },
  %{
    name: "Mobile number", code: "mobile_number", input_type: "number",
    description: "Mobile number"
  },
]

for variable <- other_variables do
  EmailTemplates.create_email_variable(variable)
end
