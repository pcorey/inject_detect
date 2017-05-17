defmodule InjectDetect.Event.SentWelcomeEmail do
  defstruct user_id: nil,
            email: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SentWelcomeEmail do

  def apply(event, state), do: state

end
