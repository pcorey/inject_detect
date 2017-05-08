defmodule InjectDetect.Event.RemovedExpectedQuery do
  defstruct application_id: nil,
    query_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.RemovedExpectedQuery do

  alias InjectDetect.State.ExpectedQuery

  def apply(event, state) do
    ExpectedQuery.remove(state, event.query_id)
  end

end