defmodule InjectDetect.Event.SentUnexpectedEmail do
  defstruct user_id: nil,
            application_id: nil,
            query_id: nil,
            sent_at: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SentUnexpectedEmail do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:sent_unexpected_at)], event.sent_at)
  end

end
