defmodule InjectDetect.State.Application do

  alias InjectDetect.State

  def find(attrs) when is_list(attrs) do
    State.get()
    |> elem(1)
    |> get_in([:applications])
    |> Map.values()
    |> Enum.find(fn user -> Enum.all?(attrs, fn {k, v} -> user[k] == v end) end)
  end

  def find(token) do
    State.get()
    |> elem(1)
    |> get_in([:applications, token])
  end

end
