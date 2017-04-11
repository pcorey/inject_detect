defmodule InjectDetect.Event.TurnedOffTrainingMode do
  defstruct application_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.TurnedOffTrainingMode do

  def apply(event, state) do
    put_in(state, [:applications, event.application_id, :training_mode], false)
  end

end
