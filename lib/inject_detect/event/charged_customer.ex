defmodule InjectDetect.Event.ChargedCustomer do
  defstruct user_id: nil,
            charge_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.ChargedCustomer do

  def apply(event, state) do
    state
  end

end
