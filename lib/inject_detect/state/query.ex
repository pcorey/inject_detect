defmodule InjectDetect.State.Query do


  def to_key(query) do
    %{collection: query[:collection],
      query: query[:query],
      type: query[:type]}
  end


  def hash(query) do
    binary = query
    |> to_key
    |> :erlang.term_to_binary
    :crypto.hash(:sha256, binary)
    |> Base.encode16
  end


  def find(state, user_id, application_id, query) do
    Lens.key(:users)
    |> Lens.filter(&(&1.id == user_id))
    |> Lens.key(:applications)
    |> Lens.filter(&(&1.id == application_id))
    |> Lens.key(:queries)
    |> Lens.filter(&(&1.id == hash(query)))
    |> Lens.to_list(state)
    |> List.first
  end


  def mark_as_expected(state, user_id, application_id, id) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == user_id)),
                   Lens.key(:applications),
                   Lens.filter(&(&1.id == application_id)),
                   Lens.key(:queries),
                   Lens.filter(&(&1.id == id)),
                   Lens.key(:expected)], true)
  end


end
