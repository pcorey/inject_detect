defmodule InjectDetect.State.Base do

  def new, do: %{users: []}

  def add_user(state, user) do
    user = Map.put_new(user, :applications, [])
    update_in(state, [:users], &([user | &1]))
  end

end
