defmodule MyHive.CaseAssigner do
  alias MyHive.CaseManagement
  alias MyHive.Accounts

  def call(prof_id) do
    profs_cases = CaseManagement.cases_with_user(prof_id)
    sophie = Accounts.get_user!(42)
    anthony = Accounts.get_user!(18)
    viv = Accounts.get_user!(7)
    mar = Accounts.get_user!(27)
    Enum.each(profs_cases, fn mlc ->
      if !has_user?(mlc, sophie) do
        CaseManagement.add_to_user_to_case(sophie, mlc)
      end
      if !has_user?(mlc, anthony) do
        CaseManagement.add_to_user_to_case(anthony, mlc)
      end
      if !has_user?(mlc, viv) do
        CaseManagement.add_to_user_to_case(viv, mlc)
      end
      CaseManagement.del_user_medico_legal_cases(mlc, [27])
    end)
  end

  def has_user?(mlc, user) do
    Enum.member?(mlc.users, user)
  end

end
MyHive.CaseAssigner.call(System.get_env("US_ID"))
