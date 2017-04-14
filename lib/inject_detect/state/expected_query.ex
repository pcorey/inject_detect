defmodule InjectDetect.State.ExpectedQuery do

  alias InjectDetect.State

  def find(application_id, key) do
    State.get()
    |> elem(1)
    |> get_in([:expected_queries, application_id, key])
  end

end
