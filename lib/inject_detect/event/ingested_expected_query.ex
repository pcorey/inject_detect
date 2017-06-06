defmodule InjectDetect.Event.IngestedExpectedQuery do
  defstruct application_id: nil,
            collection: nil,
            id: nil,
            queried_at: nil,
            query: nil,
            type: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedExpectedQuery do

  import InjectDetect.State.Application, only: [touch_expected_query: 4]

  def apply(event, state) do
    touch_expected_query(state, event.user_id, event.application_id, Map.from_struct(event))
  end

end
