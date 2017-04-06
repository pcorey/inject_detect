defmodule InjectDetect.State.User do

  def get() do
  end

  def add_application(state, user, attrs) do
    application = Enum.into(attrs, %{})
    state
    |> InjectDetect.State.Base.update_user(user, fn
      user ->
        update_in(user, [:applications], fn apps -> apps ++ [application] end)
    end)
  end

end
