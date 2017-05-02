defmodule InjectDetect.State.Base do

  alias InjectDetect.State.User

  def new, do: %{users: []}

  def add_user(state, user) do
    user = User.new(user)
    update_in(state, [:users], &([user | &1]))
  end

end
