defmodule InjectDetect.Event.GivenAuthToken do
  defstruct auth_token: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

  def stream(event), do: "user_id: #{event.user_id}"

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.GivenAuthToken do

  def apply(event, state) do
    state
    |> put_in([:users, event.user_id, :auth_token], event.auth_token)
  end

end
