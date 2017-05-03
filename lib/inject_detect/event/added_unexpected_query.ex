defmodule InjectDetect.Event.AddedUnexpectedQuery do
  defstruct application_id: nil,
            id: nil,
            collection: nil,
            queried_at: nil,
            query: nil,
            type: nil,
            similar_query: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.AddedUnexpectedQuery do

  import InjectDetect.State.Application, only: [add_unexpected_query: 3]

  def apply(event, state) do
    add_unexpected_query(state, event.application_id, Map.from_struct(event))
  end

end
