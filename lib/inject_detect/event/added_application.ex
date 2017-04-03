defmodule InjectDetect.Event.AddedApplication do
  defstruct application_id: nil,
            application_name: nil,
            application_size: nil,
            application_token: nil,
            user_id: nil

  def convert_from(event, _), do: struct(__MODULE__, event)

end

defimpl InjectDetect.State.Reducer,
   for: InjectDetect.Event.AddedApplication do

  def apply(%{application_id: application_id,
              application_name: application_name,
              application_size: application_size,
              application_token: application_token,
              user_id: user_id}, state) do
    update_in(state, [:users,
                      user_id,
                      :applications], fn
      applications -> applications ++ [%{application_name: application_name,
                                         application_size: application_size,
                                         applicatino_token: application_token,
                                         expected_queries: [],
                                         unexpected_queries: [],
                                         id: application_id}]
    end)
  end

end
