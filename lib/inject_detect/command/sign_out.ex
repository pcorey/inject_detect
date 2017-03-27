defmodule InjectDetect.Command.SignOut do

  defstruct user_id: nil

  alias __MODULE__

  def handle(arguments = %{user_id: user_id}) do
    data = Map.from_struct(arguments)
    {:ok, [{:signed_out, user_id, data}]}
  end

  def resolve(_args, %{context: %{current_user: current_user}}) do
    command = %SignOut{ user_id: current_user.id }
    with {:ok, [{_, id, _}]} <- InjectDetect.CommandHandler.handle(command) do
      {:ok, %{id: id}}
    else
      {:error, error} -> {:error, error}
      error           -> {:error, error}
    end
  end

end
