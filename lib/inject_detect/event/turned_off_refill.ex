defmodule InjectDetect.Event.TurnedOffRefill do
  defstruct user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
  for: InjectDetect.Event.TurnedOffRefill do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:refill)], false)
  end

end
