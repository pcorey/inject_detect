defmodule InjectDetect.Event.SignedOut do
  defstruct user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SignedOut do

  def apply(%{user_id: user_id}, state) do
    put_in(state, [:users,
                   InjectDetect.State.all_with(id: user_id),
                   :auth_token], nil)
  end

end
