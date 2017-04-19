defmodule InjectDetect.Event.AddedExpectedQuery do
  defstruct id: nil,
            application_id: nil,
            collection: nil,
            queried_at: nil,
            query: nil,
            type: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.AddedExpectedQuery do

  alias InjectDetect.State.Query

  def apply(event, state) do
    query = %{
      collection: event.collection,
      queried_at: event.queried_at,
      query: event.query,
      type: event.type
    }
    Lens.key(:users)
    |> Lens.all
    |> Lens.key(:applications)
    |> Lens.filter(&(&1.id == event.application_id))
    |> Lens.key(:expected_query)
    |> Lens.map(state, &([query | &1]))
  end

end
