defmodule InjectDetect.Event.SentVerifyEmail do
  defstruct user_id: nil,
            requested_token: nil,
            email: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SentVerifyEmail do

  def apply(event, state), do: state

end
