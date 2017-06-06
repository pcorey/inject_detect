defmodule InjectDetect.Event.RegeneratedApplicationToken do
  defstruct application_id: nil,
            token: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.RegeneratedApplicationToken do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:applications),
                   Lens.filter(&(&1.id == event.application_id)),
                   Lens.key(:token)], event.token)
  end

end
