defmodule InjectDetect.State.UnexpectedQuery do

  def new(attrs) do
    attrs
    |> Map.put_new(:seen, 1)
  end

  def find(application_id, key) do
    State.get()
    |> elem(1)
    |> get_in([:unexpected_queries, application_id, key])
  end

end
