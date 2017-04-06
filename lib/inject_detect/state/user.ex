defmodule InjectDetect.State.User do

  import InjectDetect.State.Base, only: [with_attrs: 1]

  def find_application(state, attrs) do
    get_in(state, [:users, Access.all, :applications, with_attrs(attrs)])
    |> List.flatten
    |> List.first
  end

  def find_application(state, user_id, attrs) do
    get_in(state, [:users, with_attrs(id: user_id), :applications, with_attrs(attrs)])
    |> List.flatten
    |> List.first
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
