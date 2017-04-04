defmodule InjectDetect.Event.IngestedExpectedQueries do
  defstruct application_id: nil,
            queries: []

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedExpectedQueries do

  def apply(event, state) do
    state
    # application = Map.from_struct(event)
    # |> Map.delete(:application_id)
    # |> Map.put_new(:id, event.application_id)
    # state = update_in(state,
    #   [:users,
    #    InjectDetect.State.all_with(:id, event.user_id),
    #    :applications],
    #   fn applications ->
    #     applications ++ [application]
    #   end)
  end

end
