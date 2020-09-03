alias MyHive.{CVFields, Accounts, Repo}

cv_fields = [%{
  name: "Name", field_type: "string", order: 1
},%{
  name: "Current position", field_type: "string", order: 2
}, %{
  name: "Qualifications", field_type: "string", order: 3
}, %{
  name: "GMC No", field_type: "string", order: 4
},%{
  name: "Indemnity", field_type: "string", order: 5
}, %{
  name: "Clinic", field_type: "string",order: 6
}, %{
  name: "Email", field_type: "string", order: 8
}, %{
  name: "ICO", field_type: "string", order: 7
}, %{
  name: "Telephone Number", field_type: "string", order: 9
}, %{
  name: "Clinical Practice and Experience",field_type: "text", order: 10
}, %{
  name: "Clinical Interests", field_type: "text", order: 11
}, %{
  name: "Research Interests", field_type: "text", order: 12
}, %{
  name: "Summary of Publications", field_type: "text", order: 13
}, %{
  name: "Teaching and Training", field_type: "text", order: 14
}, %{
  name: "Prizes and Awards", field_type: "text", order: 15
},%{
  name: "Memberships of Professional Bodies and Learned Societies",
  field_type: "text", order: 16
}, %{
  name: "Medico-Legal", field_type: "text", order: 17
}]
users = Accounts.list_users()
Repo.transaction(fn ->
  Enum.each(cv_fields, fn cv_field ->
    CVFields.create_field(cv_field)
  end)
  Enum.each(users, fn user ->
    Enum.each(CVFields.all(), fn field ->
      CVFields.create_user_cv_field(user, field)
    end)
  end)
end)
