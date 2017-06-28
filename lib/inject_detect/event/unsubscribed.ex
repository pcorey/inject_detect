defmodule InjectDetect.Event.Unsubscribed do
  defstruct user_id: nil
end

defimpl InjectDetect.State.Reducer,
  for: InjectDetect.Event.Unsubscribed do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:subscribed)], false)
  end

end
