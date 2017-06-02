defmodule InjectDetect.Event.UpdatedCustomer do
  defstruct user_id: nil


  def convert_from(event, _), do: struct(__MODULE__, event)


end


defimpl InjectDetect.State.Reducer, for: InjectDetect.Event.UpdatedCustomer do


  def apply(event, state), do: state


end
