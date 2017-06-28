defmodule InjectDetect.Event.SentOutOfCreditsEmail do
  defstruct user_id: nil,
            application_id: nil,
            query_id: nil,
            sent_at: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.SentOutOfCreditsEmail do

  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:sent_out_of_credits_at)], event.sent_at)
  end

end
