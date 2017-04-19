defmodule InjectDetect.State.User do

  alias InjectDetect.State.Application

  def new(attrs), do: Map.put_new(attrs, :applications, [])

  def find(state, attrs) when is_list(attrs) do
    Lens.key(:users)
    |> Lens.filter(fn user -> Enum.all?(attrs, fn {k, v} -> user[k] == v end) end)
    |> Lens.to_list(state)
    |> List.first
  end

  def find(state, id) do
    Lens.key(:users)
    |> Lens.filter(&(&1.id == id))
    |> Lens.to_list(state)
    |> List.first
  end

  def add_application(state, user_id, application) do
    Lens.key(:users)
    |> Lens.filter(&(&1.id == user_id))
    |> Lens.key(:applications)
    |> Lens.map(state, &([Application.new(application) | &1]))
  end

end
