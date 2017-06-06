defmodule InjectDetect.Event.SentWelcomeEmail do
  defstruct user_id: nil,
            email: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SentWelcomeEmail do

  def apply(event, state), do: state

end
