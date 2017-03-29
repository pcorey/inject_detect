defmodule InjectDetect.Event.SignedOut do
  defstruct user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SignedOut do

  def apply(event, state) do
    put_in(state, [:users, event.user_id, :auth_token], nil)
  end

end
