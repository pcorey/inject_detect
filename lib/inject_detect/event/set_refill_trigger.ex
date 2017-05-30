defmodule InjectDetect.Event.SetRefillTrigger do
  defstruct user_id: nil,
            refill_trigger: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SetRefillTrigger do

  alias InjectDetect.State.User

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:refill_trigger)], event.refill_trigger)
  end

end
