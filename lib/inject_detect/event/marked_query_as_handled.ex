defmodule InjectDetect.Event.MarkedQueryAsHandled do
  defstruct application_id: nil,
            query_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.MarkedQueryAsHandled do

  alias InjectDetect.State.UnexpectedQuery

  def apply(event, state) do
    UnexpectedQuery.remove(state, event.query_id)
  end

end
