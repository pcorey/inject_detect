defmodule InjectDetect.Event.SetStripeToken do
  defstruct user_id: nil,
            stripe_token: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SetStripeToken do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:stripe_token)], event.stripe_token)
  end

end
