defmodule InjectDetect.Event.SignedOut do
  defstruct user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

  def stream(event), do: "user_id: #{event.user_id}"

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SignedOut do

  def apply(%{user_id: user_id}, state) do
    state
    |> put_in([:users, user_id, :auth_token], nil)
  end

end
