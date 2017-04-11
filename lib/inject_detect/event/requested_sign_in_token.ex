defmodule InjectDetect.Event.RequestedSignInToken do
  defstruct email: nil,
            requested_token: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

  def stream(event), do: "user_id: #{event.user_id}"

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.RequestedSignInToken do

  def apply(event, state) do
    state
    |> put_in([:users, event.user_id, :requested_token], event.requested_token)
  end

end
