defmodule InjectDetect.State.User do

  alias InjectDetect.State

  def find(attrs) when is_list(attrs) do
    State.get()
    |> elem(1)
    |> get_in([:users])
    |> Map.values()
    |> Enum.find(fn user -> Enum.all?(attrs, fn {k, v} -> user[k] == v end) end)
  end

  def find(id) do
    State.get()
    |> elem(1)
    |> get_in([:users, id])
  end

end
