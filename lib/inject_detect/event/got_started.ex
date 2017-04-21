defmodule InjectDetect.Event.GotStarted do
  defstruct agreed_to_tos: nil,
            email: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.GotStarted do

  alias InjectDetect.State.Base

  def apply(event, state) do
    Base.add_user(state, %{agreed_to_tos: event.agreed_to_tos,
                           email: event.email,
                           id: event.user_id})
  end

end
