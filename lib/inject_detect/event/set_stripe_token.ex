defmodule InjectDetect.Event.SetStripeToken do
  defstruct user_id: nil,
            stripe_token: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SetStripeToken do

  def apply(event, state) do
    stripe_token = %{id: event.stripe_token["id"],
                     card: %{id: event.stripe_token["card"]["id"],
                             exp_month: event.stripe_token["card"]["exp_month"],
                             exp_year: event.stripe_token["card"]["exp_year"],
                             last4: event.stripe_token["card"]["last4"]}}
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:stripe_token)], stripe_token)
  end

end
