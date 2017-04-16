defmodule InjectDetect.Event.TurnedOnTrainingMode do
  defstruct application_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
  for: InjectDetect.Event.TurnedOnTrainingMode do

  def apply(event, state) do
    put_in(state, [:applications, event.application_id, :training_mode], true)
  end

end
