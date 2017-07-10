defmodule InjectDetect.Event.MarkedQueryAsExpected do
  defstruct application_id: nil,
            query_id: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.MarkedQueryAsExpected do

  alias InjectDetect.State.Query

  def apply(event, state) do
    Query.mark_as_expected(state, event.user_id, event.application_id, event.query_id)
  end

end
