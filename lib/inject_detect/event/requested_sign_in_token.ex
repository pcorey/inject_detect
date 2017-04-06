defmodule InjectDetect.Event.RequestedSignInToken do
  defstruct email: nil,
            requested_token: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.RequestedSignInToken do

  import InjectDetect.State, only: [with_attrs: 1]

  def apply(event, state) do
      put_in(state, [:users,
                     with_attrs(id: event.user_id),
                     :requested_token], event.requested_token)
  end

end
