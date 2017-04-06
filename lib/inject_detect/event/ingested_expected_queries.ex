defmodule InjectDetect.Event.IngestedExpectedQueries do
  defstruct application_id: nil,
            queries: []

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedExpectedQueries do

  def apply(event, state) do
    # TODO: Subtract credits
    state
  end

end
