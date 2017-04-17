defmodule InjectDetect.Event.TurnedOffAlerting do
  defstruct application_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.TurnedOffAlerting do

  def apply(event, state) do
    put_in(state, [:applications, event.application_id, :alerting], false)
  end

end
