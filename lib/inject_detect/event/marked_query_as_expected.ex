defmodule InjectDetect.Event.MarkedQueryAsExpected do
  defstruct application_id: nil,
            query_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.MarkedQueryAsExpected do

  alias InjectDetect.State.Application
  alias InjectDetect.State.UnexpectedQuery

  def apply_to_application(application, event, state) do
    query = UnexpectedQuery.find(state, event.application_id, event.query_id)
    state
    |> UnexpectedQuery.remove(event.application_id, event.query_id)
    |> Application.add_expected_query(application.user_id, application.id, query)
  end

  def apply(event, state) do
    Application.find(state, event.application_id)
    |> apply_to_application(event, state)
  end

end
