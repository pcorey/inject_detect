defmodule InjectDetect.Event.CreatedSubscription do
  defstruct user_id: nil,
            subscription_id: nil
end


defimpl InjectDetect.State.Reducer, for: InjectDetect.Event.CreatedSubscription do


  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:subscription_id)], event.subscription_id)
  end


end
