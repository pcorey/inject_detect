defmodule InjectDetect.Event.GotStarted do
  defstruct auth_token: nil,
            email: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.GotStarted do

  def apply(event, state) do
    put_in(state, [:users, event.user_id], %{id: event.user_id,
                                             auth_token: event.auth_token,
                                             email: event.email})
  end

end
