defmodule InjectDetect.Event.RegeneratedApplicationToken do
  defstruct id: nil,
            token: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.RegeneratedApplicationToken do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.all,
                   Lens.key(:applications),
                   Lens.filter(&(&1.id == event.id)),
                   Lens.key(:token)], event.token)
  end

end
