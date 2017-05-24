defmodule InjectDetect.Event.IngestedQuery do
  defstruct application_id: nil,
            collection: nil,
            queried_at: nil,
            query: nil,
            type: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.IngestedQuery do

  alias InjectDetect.State.Application

  def apply(event, state) do
    application = Application.find(state, event.application_id)
    Lens.key(:users)
    |> Lens.filter(&(&1.id == application.user_id))
    |> Lens.key(:credits)
    |> Lens.map(state, &(&1 - 1))
  end

end
