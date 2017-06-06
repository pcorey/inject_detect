defmodule InjectDetect.Event.SignedOut do
  defstruct user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SignedOut do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:auth_token)], nil)
  end

end
