defmodule InjectDetect.Event.GotStarted do
  defstruct email: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.GotStarted do

  def apply(event, state) do
    put_in(state, [:users, event.user_id], %{email: event.email,
                                             id: event.user_id})
  end

end
