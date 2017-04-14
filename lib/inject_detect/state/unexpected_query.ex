defmodule InjectDetect.State.UnexpectedQuery do

  alias InjectDetect.State

  def find(application_id, key) do
    State.get()
    |> elem(1)
    |> get_in([:unexpected_queries, application_id, key])
  end

end
