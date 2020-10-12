defmodule MyHive.CaseManagement.Services.MedicoLegalCaseMobileParamsParser do

  alias MyHive.{Accounts, ContactBook, Repo}

  def call(params, user) do
    user = Repo.preload(user, :saas_accounts)
    account = user.saas_accounts |> List.first
    params
     |> update_user_names_in_params(params["user_names"])
     |> update_patient_name_in_params(params["patient_name"])
     |> set_notifications_disabled(params["notifications_disabled"])
     |> add_addressable_type("instructing_party")
     |> add_addressable_type("patient")
     |> add_addressable_type("claimant")
     |> add_person_type("patient")
     |> add_person_type("claimant")
     |> Map.put("user_id", user.id)
     |> Map.put("account_id", account.id)
  end

  defp update_user_names_in_params(params, names) do
    ids = names |> String.split(",")
      |> Enum.map(fn name ->
        first_name = name |> String.split(" ") |> List.first
        last_name = name |> String.split(" ") |> List.last
        user = Accounts.by_first_and_last_name(first_name, last_name)
        to_string(user.id)
      end)
    Map.put(params, "user_ids", ids)
  end

  defp update_patient_name_in_params(params, name) when is_binary(name) do
      first_name = params["patient_name"] |> String.split(" ") |> List.first
      last_name = params["patient_name"] |> String.split(" ") |> List.last
      patient = ContactBook.by_first_and_last_name(first_name, last_name)
      Map.put(params, "patient_id", to_string(patient.id))
  end

  defp update_patient_name_in_params(params, name) when is_nil(name) do
    params
  end

  defp set_notifications_disabled(params, not_disabled) do
    if (not_disabled == "On") do
      Map.put(params, "notifications_disabled", false)
    else
      Map.put(params, "notifications_disabled", true)
    end
  end

  defp add_addressable_type(params, key) do
    if is_nil(params[key]) == false do
      item_map = params[key]["addresses"]["0"]
      address_map = Map.put(item_map, "addressable_type",  Macro.camelize(key))
      address = Map.put(params[key]["addresses"], "0", address_map)
      hash = Map.put(params[key], "addresses", address)
      Map.put(params, key, hash)
    else
      params
    end
  end

  defp add_person_type(params, key) do
    if is_nil(params[key]) == false do
      patient = Map.put(params[key], "person_type", Macro.camelize(key))
      Map.put(params, key, patient)
    else
      params
    end
  end


end
