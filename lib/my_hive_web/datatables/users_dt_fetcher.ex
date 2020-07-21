defmodule MyHive.Datatables.UsersDtFetcher do

  alias MyHive.Repo
  alias MyHive.Accounts.User
  import Ecto.Query
  def get_users(page_size, page_number, search_term, order) do
    query = from user in User,
    select: struct(user, [:id,
                         :first_name,
                         :last_name,
                         :email,
                         :phone_number,
                         :roles])
    query = from user in query,
            order_by: ^order
    query = add_filter(query, search_term)
    Repo.paginate(query,
                  page: page_number,
                  page_size: page_size)
  end

  defp add_filter(query, search_term) when search_term == nil or search_term == "", do: query

  defp add_filter(query, original_search_term) do
    search_term = "%#{original_search_term}%"
    from user in query,
    where: ilike(user.first_name, ^search_term) or
           ilike(user.last_name, ^search_term) or
           ilike(user.email, ^search_term)
  end

end
