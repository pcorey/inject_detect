defmodule InjectDetect.Event.IngestedQuery do
  defstruct application_id: nil,
            collection: nil,
            queried_at: nil,
            query: nil,
            type: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedQuery do

  def apply(event, state) do
    Lens.key(:users)
    |> Lens.filter(&(&1.id == event.user_id))
    |> Lens.key(:credits)
    |> Lens.map(state, &(&1 - 1))
  end

end
