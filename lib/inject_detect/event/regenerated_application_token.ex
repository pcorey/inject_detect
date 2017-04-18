defmodule InjectDetect.Event.RegeneratedApplicationToken do
  defstruct id: nil,
            token: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.RegeneratedApplicationToken do

  def apply(event, state) do
    old_token = get_in(state, [:applications, event.id, :token])
    state
    |> put_in([:applications, event.id, :token], event.token)
    |> put_in([:application_tokens, event.token], event.id)
    |> put_in([:application_tokens, old_token], nil)
  end

end
