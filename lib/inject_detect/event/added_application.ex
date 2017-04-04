defmodule InjectDetect.Event.AddedApplication do
  defstruct application_id: nil,
            application_name: nil,
            application_size: nil,
            application_token: nil,
            alerting: true,
            expected_queries: [],
            unexpected_queries: [],
            ingesting_queries: true,
            training_mode: true,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.AddedApplication do

  def apply(event, state) do
    application = Map.from_struct(event)
    |> Map.delete(:application_id)
    |> Map.put_new(:id, event.application_id)
    state = update_in(state,
                      [:users,
                       InjectDetect.State.all_with(id: event.user_id),
                       :applications],
                      fn applications ->
                        applications ++ [application]
                      end)
  end

end
