alias MyHive.EmailTemplates
alias MyHive.EmailTemplates.{
  EmailTemplateVariable
}

default_variables = [
  %{name: "Recipient Name", code: "recipient_name", input_type: "text",
    description: "Email recipient name", is_default: true},
  %{name: "Expert Name", code: "expert_name", input_type: "select",
    description: "Expert first and last name", is_default: true},
  %{name: "Expert Discipline", code: "expert_discipline", input_type: "text",
    description: "Experts specialty", is_default: true},
  %{name: "Free Text", code: "free_text", input_type: "textarea",
    description: "Free text entered by user, can be longer than one line",
    is_default: true},
  %{name: "Hourly Rate", code: "hourly_rate", input_type: "number",
    description: "Hourly rate", is_default: true},
  %{name: "Date", code: "date", input_type: "datepicker",
    description: "Date selected from datepicker", is_default: true},
  %{name: "Free Text One line", code: "free_text_one_line",
    input_type: "text", is_default: true,
    description: "One line of text"},
  %{name: "Court name", code: "court_name", input_type: "text",
    description: "Name of the court", is_default: true},
  %{name: "Numbers of hours", code: "hours_numbers", input_type: "number",
    description: "Numbers of hours", is_default: true}
]

for variable <- default_variables do
  EmailTemplates.create_email_variable(variable)
end



default_templates = [
  %{name: "Hearing", body: "Please enter email body here",
    email_template_variables: [
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("recipient_name").id
      },
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("expert_name").id
      },
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("court_name").id
      },
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("date").id
      },
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("free_text_one_line").id
      }
    ]
  },
  %{name: "Medical Report - no questions", body: "Please enter email body here",
    email_template_variables: [
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("expert_name").id,
      },
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("expert_discipline").id,
      }
    ]},
  %{name: "Medical Report - questions",
    body: "Please enter email body here",
    email_template_variables: [
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("expert_name").id,
      }
    ]
  },
  %{name: "Feedback Request", body:  "Please enter email body here",
    email_template_variables: [
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("recipient_name").id
      }
    ]
  },
  %{name: "Cost Budget Request", body:  "Please enter email body here",
  email_template_variables: [
    %EmailTemplateVariable{
      template_variable_id: EmailTemplates.get_variable_by_code("date").id
    },
    %EmailTemplateVariable{
      template_variable_id: EmailTemplates.get_variable_by_code("hourly_rate").id
    }
  ]
  },
  %{name: "Screening medical report", body: "Please enter email body here",
    email_template_variables: [
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("expert_name").id
      },
      %EmailTemplateVariable{
        template_variable_id: EmailTemplates.get_variable_by_code("expert_discipline").id
      }
    ]
  }
]

for template <- default_templates do
  variables = template.email_template_variables
  {:ok, et} = EmailTemplates.create_email_template(template)
  for variable <- variables do
    variable = Map.put(variable, :email_template_id, et.id)
    EmailTemplates.create_join_table_var(et.id, variable.template_variable_id)
  end
end
