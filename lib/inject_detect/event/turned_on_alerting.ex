defmodule InjectDetect.Event.TurnedOnAlerting do
  defstruct application_id: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.TurnedOnAlerting do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:applications),
                   Lens.filter(&(&1.id == event.application_id)),
                   Lens.key(:alerting)], true)
  end

end
