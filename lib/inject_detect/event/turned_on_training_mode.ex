defmodule InjectDetect.Event.TurnedOnTrainingMode do
  defstruct application_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
  for: InjectDetect.Event.TurnedOnTrainingMode do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.all,
                   Lens.key(:applications),
                   Lens.filter(&(&1.id == event.application_id)),
                   Lens.key(:training_mode)], true)
  end

end
