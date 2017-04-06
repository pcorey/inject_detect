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

  def apply(event, state) do
    application = %{id: event.id,
                    name: event.name,
                    size: event.size,
                    token: event.token,
                    user_id: event.user_id,
                    alerting: true,
                    expected_queries: [],
                    unexpected_queries: [],
                    ingesting_queries: true,
                    training_mode: true}
    state
    |> put_in([:applications, event.token], application)
    |> update_in([:users, event.user_id, :applications], fn apps -> [event.token | apps] end)
  end

end
