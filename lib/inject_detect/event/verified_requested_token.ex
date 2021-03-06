defmodule InjectDetect.Event.VerifiedRequestedToken do
  defstruct token: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.VerifiedRequestedToken do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:requested_token)], nil)
  end

end
