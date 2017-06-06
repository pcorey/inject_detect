defmodule InjectDetect.Event.ChargedCustomer do
  defstruct user_id: nil,
            charge_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.ChargedCustomer do

  def apply(event, state) do
    state
  end

end
