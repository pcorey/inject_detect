defmodule InjectDetect.Event.AddedCredits do
  defstruct user_id: nil,
            credits: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.AddedCredits do

  alias InjectDetect.State.User

  def apply(event, state) do
    User.add_credits(state, event.user_id, event.credits)
  end

end
