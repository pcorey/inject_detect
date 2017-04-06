defmodule InjectDetect.Event.SignedOut do
  defstruct user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SignedOut do

  import InjectDetect.State, only: [with_attrs: 1]

  def apply(%{user_id: user_id}, state) do
    put_in(state, [:users,
                   with_attrs(id: user_id),
                   :auth_token], nil)
  end

end
