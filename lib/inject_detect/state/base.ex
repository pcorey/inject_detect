defmodule InjectDetect.State.Base do

  def new(), do: %{users: []}

  defp with_attrs(attrs) do
    matches = fn user -> Enum.all?(attrs, fn {k, v} -> user[k] == v end) end
    fn
      (:get, users, next) ->
        Enum.filter(users, matches)
        |> Enum.map(next)
      (:get_and_update, users, next) ->
        Enum.map(users, fn user -> matches.(user)
                                   |> case do
                                        true  -> next.(user)
                                        false -> {nil, user}
                                      end
                        end)
        |> :lists.unzip
    end
  end

  def add_user(state, attrs) do
    update_in(state.users, fn users -> users ++ [Enum.into(attrs, %{applications: []})] end)
  end

  def find_user(state, attrs) do
    get_in(state, [:users, with_attrs(attrs)])
  end

  def update_user(state, attrs, update) do
    update_in(state, [:users, with_attrs(attrs)], update)
  end

end
