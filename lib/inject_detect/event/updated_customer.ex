defmodule InjectDetect.Event.UpdatedCustomer do
  defstruct user_id: nil
end


defimpl InjectDetect.State.Reducer, for: InjectDetect.Event.UpdatedCustomer do


  def apply(event, state), do: state


end
