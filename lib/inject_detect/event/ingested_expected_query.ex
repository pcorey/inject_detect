defmodule InjectDetect.Event.IngestedExpectedQuery do
  defstruct application_id: nil,
            collection: nil,
            id: nil,
            queried_at: nil,
            query: nil,
            type: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedExpectedQuery do

  import InjectDetect.State.Application, only: [touch_expected_query: 3]

  def apply(event, state) do
    touch_expected_query(state, event.application_id, Map.from_struct(event))
  end

end
