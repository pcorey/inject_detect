defmodule InjectDetect.Event.GotStarted do
  defstruct agreed_to_tos: nil,
            email: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.GotStarted do

  import InjectDetect.State, only: [with_attrs: 1]

  def apply(event, state) do
    user = %{applications: [],
             agreed_to_tos: event.agreed_to_tos,
             email: event.email,
             id: event.user_id}
    path = [:users]
    update_in(state, path, fn users -> users ++ [user] end)
  end

end
