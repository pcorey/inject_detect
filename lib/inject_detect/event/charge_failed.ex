defmodule InjectDetect.Event.ChargeFailed do
  defstruct user_id: nil,
            response: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.ChargeFailed do

  def apply(event, state) do
    state
  end

end
