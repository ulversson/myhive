defmodule MyHive.Datatables.UsersDtFetcher do 

  alias MyHive.Repo
  alias MyHive.Accounts.User
  import Ecto.Query

  def get_users(page_size, page_number, search_term) do
    query = from user in User,
    select: struct(user, [:id,
                         :first_name,
                         :last_name,
                         :email,
                         :phone_number,
                         :roles])
    query = from user in query,
            order_by: [desc: user.id]
    query = add_filter(query, search_term)
    Repo.paginate(query,
                  page: page_number,
                  page_size: page_size)
  end

  defp add_filter(query, search_term) when search_term == nil or search_term == "", do: query

  defp add_filter(query, original_search_term) do
    search_term = "#{original_search_term}%"
    from user in query,
    where: like(user.id, ^search_term) or
           like(user.first_name, ^search_term) or
           like(user.last_name, ^search_term) or
           like(user.email, ^search_term) or
           like(user.phone_number, ^search_term) or
           like(user.roles, ^search_term)
  end

end  