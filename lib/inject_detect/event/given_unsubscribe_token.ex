defmodule InjectDetect.Event.GivenUnsubscribeToken do
  defstruct unsubscribe_token: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.GivenUnsubscribeToken do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:unsubscribe_token)], event.unsubscribe_token)
  end

end
