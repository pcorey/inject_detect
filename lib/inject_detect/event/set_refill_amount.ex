defmodule InjectDetect.Event.SetRefillAmount do
  defstruct user_id: nil,
            refill_amount: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SetRefillAmount do

  alias InjectDetect.State.User

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:refill_amount)], event.refill_amount)
  end

end
