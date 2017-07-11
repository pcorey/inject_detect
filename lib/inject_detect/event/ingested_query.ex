defmodule InjectDetect.Event.IngestedQuery do
  defstruct application_id: nil,
            collection: nil,
            queried_at: nil,
            query: nil,
            type: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer, for: InjectDetect.Event.IngestedQuery do

  def apply(event, state) do
    update_in(state, [Lens.key(:users),
                      Lens.filter(&(&1.id == event.user_id)),
                      Lens.key(:ingests_pending_invoice)], &(&1 + 1))
  end

end
