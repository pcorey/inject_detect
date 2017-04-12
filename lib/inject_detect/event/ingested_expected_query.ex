defmodule InjectDetect.Event.IngestedExpectedQuery do
  defstruct application_id: nil,
    collection: nil,
    queried_at: nil,
    query: nil,
    type: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedExpectedQuery do

  def apply(event, state) do
    state
  end

end