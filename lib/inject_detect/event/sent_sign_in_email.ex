defmodule InjectDetect.Event.SentSignInEmail do
  defstruct user_id: nil,
            requested_token: nil,
            email: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SentSignInEmail do

  def apply(event, state), do: state

end
