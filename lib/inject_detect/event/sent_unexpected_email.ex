defmodule InjectDetect.Event.SentUnexpectedEmail do
  defstruct user_id: nil,
            application_id: nil,
            query_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SentUnexpectedEmail do

  def apply(event, state), do: state

end
