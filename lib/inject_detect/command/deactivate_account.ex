defmodule InjectDetect.Command.DeactivateAccount do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.DeactivateAccount do

  alias InjectDetect.Event.DeactivatedAccount

  def handle(%{user_id: user_id}, %{user_id: user_id}, _state) do
    {:ok, [%DeactivatedAccount{user_id: user_id}]}
  end

  def handle(_, _, _), do: InjectDetect.error("Not authorized")

end
