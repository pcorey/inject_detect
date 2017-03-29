defmodule InjectDetect.Event.VerifiedRequestedToken do
  defstruct token: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.VerifiedRequestedToken do

  def apply(event, state) do
    put_in(state, [:users, event.user_id, :auth_token], event.auth_token)
  end

end
