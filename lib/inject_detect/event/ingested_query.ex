defmodule InjectDetect.Event.IngestedQuery do
  defstruct application_id: nil,
            collection: nil,
            queried_at: nil,
            query: nil,
            type: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedQuery do

  def apply(event, state) do
    # TODO: Track ingested queries since last invoice
    state
  end

end
