defmodule InjectDetect.Event.AddedExpectedQuery do
  defstruct application_id: nil,
            id: nil,
            collection: nil,
            queried_at: nil,
            query: nil,
            type: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.AddedExpectedQuery do

  import InjectDetect.State.Application, only: [add_expected_query: 4]

  def apply(event, state) do
    add_expected_query(state, event.user_id, event.application_id, Map.from_struct(event))
  end

end
