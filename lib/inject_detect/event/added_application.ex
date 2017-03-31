defmodule InjectDetect.Event.AddedApplication do
  defstruct application_id: nil,
            application_name: nil,
            application_size: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.AddedApplication do

  def apply(%{application_id: application_id,
              application_name: application_name,
              application_size: application_size,
              user_id: user_id}, state) do
    put_in(state, [:users,
                   user_id,
                   :applications,
                   application_id], %{application_name: application_name,
                                      application_size: application_size,
                                      id: application_id})
  end

end
