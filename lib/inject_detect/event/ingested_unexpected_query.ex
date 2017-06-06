defmodule InjectDetect.Event.IngestedUnexpectedQuery do
  defstruct application_id: nil,
            collection: nil,
            id: nil,
            queried_at: nil,
            query: nil,
            type: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedUnexpectedQuery do

  import InjectDetect.State.Application, only: [touch_unexpected_query: 4]

  def apply(event, state) do
    touch_unexpected_query(state, event.user_id, event.application_id, Map.from_struct(event))
  end

end
