defmodule InjectDetect.Event.AddedApplication do
  defstruct id: nil,
            name: nil,
            size: nil,
            token: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.AddedApplication do

  import InjectDetect.State, only: [with_attrs: 1]

  def apply(event, state) do
    app = %{id: event.id,
            name: event.name,
            size: event.size,
            token: event.token,
            user_id: event.user_id,
            alerting: true,
            expected_queries: [],
            unexpected_queries: [],
            ingesting_queries: true,
            training_mode: true}
    path = [:users, with_attrs(id: event.user_id), :applications]
    state = update_in(state, path, fn apps -> apps ++ [app] end)
  end

end
