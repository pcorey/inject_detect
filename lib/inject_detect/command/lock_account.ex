defmodule InjectDetect.Command.LockAccount do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.LockAccount do

  alias InjectDetect.Event.LockedAccount

  def handle(%{user_id: user_id}, %{user_id: user_id}, _state) do
    {:ok, [%LockedAccount{user_id: user_id}]}
  end

  def handle(_, _, _), do: InjectDetect.error("Not authorized")

end
