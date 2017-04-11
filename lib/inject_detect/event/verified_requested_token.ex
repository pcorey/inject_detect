defmodule InjectDetect.Event.VerifiedRequestedToken do
  defstruct token: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

  def stream(event), do: "user_id: #{event.user_id}"

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.VerifiedRequestedToken do

  def apply(%{user_id: user_id}, state) do
    state
    |> put_in([:users, user_id, :requested_token], nil)
  end

end
