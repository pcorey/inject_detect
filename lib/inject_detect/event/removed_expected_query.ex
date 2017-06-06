defmodule InjectDetect.Event.RemovedExpectedQuery do
  defstruct application_id: nil,
            query_id: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.RemovedExpectedQuery do

  alias InjectDetect.State.ExpectedQuery

  def apply(event, state) do
    ExpectedQuery.remove(state, event.user_id, event.application_id, event.query_id)
  end

end
