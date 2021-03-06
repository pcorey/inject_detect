defmodule InjectDetect.Event.AddedApplication do
  defstruct id: nil,
            name: nil,
            size: nil,
            token: nil,
            user_id: nil
end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.AddedApplication do

  alias InjectDetect.State.User

  def apply(event, state) do
    User.add_application(state, event.user_id, %{id: event.id,
                                                 name: event.name,
                                                 size: event.size,
                                                 token: event.token,
                                                 user_id: event.user_id})
  end

end
