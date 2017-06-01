defmodule InjectDetect.Event.CreatedCustomer do
  defstruct user_id: nil,
            customer_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.CreatedCustomer do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:customer_id)], event.customer_id)
  end

end
