defmodule InjectDetect.Event.GivenAuthToken do
  defstruct auth_token: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.GivenAuthToken do

  def apply(event, state) do
    Lens.key(:users)
    |> Lens.filter(&(&1.id == event.user_id))
    |> Lens.key(:auth_token)
    |> Lens.map(state, event.auth_token)
  end

end
