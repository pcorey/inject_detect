defmodule InjectDetect.State.Application do

  def get() do
  end

  def add(state, user_id, application) do
    update_in(state,
              [:users,
               InjectDetect.State.all_with(id: user_id),
               :applications],
              fn applications ->
                applications ++ [application]
              end)
  end

end
