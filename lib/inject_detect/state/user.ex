defmodule InjectDetect.State.User do

  alias InjectDetect.State
  alias InjectDetect.State.Application

  def new(attrs) do
    attrs
    |> Map.put_new(:applications, [])
    |> Map.put_new(:credits, 0)
    |> Map.put_new(:subscribed, true)
    |> Map.put_new(:refill, false)
    |> Map.put_new(:refill_trigger, 1_000)
    |> Map.put_new(:refill_amount, 10_000)
    |> Map.put_new(:ingests_pending_invoice, 0)
  end

  def find(attrs) do
    State.get()
    |> elem(1)
    |> find(attrs)
  end

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

  def remove_application(state, user_id, application_id) do
    Lens.key(:users)
    |> Lens.filter(&(&1.id == user_id))
    |> Lens.key(:applications)
    |> Lens.map(state, &Enum.filter(&1, fn %{id: id} -> id != application_id end))
  end

  def add_credits(state, user_id, credits) do
    Lens.key(:users)
    |> Lens.filter(&(&1.id == user_id))
    |> Lens.key(:credits)
    |> Lens.map(state, &(&1 + credits))
  end

end
