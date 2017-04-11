defmodule InjectDetect.Event.AddedApplication do
  defstruct id: nil,
            name: nil,
            size: nil,
            token: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

  def stream(event), do: "user_id: #{event.user_id}"

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
    |> put_in([:applications, event.id], application)
    |> put_in([:application_tokens, event.token], event.id)
    |> put_in([:expected_queries, event.id], %{})
    |> put_in([:unexpected_queries, event.id], %{})
    |> update_in([:users, event.user_id, :applications], fn apps -> [event.id | apps] end)
  end

end
