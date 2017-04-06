defmodule InjectDetect.Event.GivenAuthToken do
  defstruct auth_token: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.GivenAuthToken do

  import InjectDetect.State, only: [with_attrs: 1]

  def apply(event, state) do
    path = [:users, with_attrs(id: event.user_id), :auth_token]
    put_in(state, path, event.auth_token)
  end

end
