defmodule InjectDetect.Event.TurnedOnRefill do
  defstruct user_id: nil
end

defimpl InjectDetect.State.Reducer,
  for: InjectDetect.Event.TurnedOnRefill do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:refill)], true)
  end

end
