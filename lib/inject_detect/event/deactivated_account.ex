defmodule InjectDetect.Event.DeactivatedAccount do
  defstruct user_id: nil
end

defimpl InjectDetect.State.Reducer, for: InjectDetect.Event.DeactivatedAccount do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:active)], false)
  end

end
