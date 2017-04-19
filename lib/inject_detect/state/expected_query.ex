defmodule InjectDetect.State.ExpectedQuery do

  def new(attrs) do
    attrs
    |> Map.put_new(:seen, 1)
  end

  def find(application_id, key) do
    State.get()
    |> elem(1)
    |> get_in([:expected_queries, application_id, key])
  end

end
