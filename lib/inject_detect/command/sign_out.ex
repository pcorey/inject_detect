defmodule InjectDetect.Command.SignOut do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.SignOut do

  alias InjectDetect.Event.SignedOut

  def handle(%{user_id: user_id}, %{user_id: user_id}, state) do
    {:ok, [%SignedOut{user_id: user_id}], %{user_id: user_id}}
  end

  def handle(_, _, _), do: InjectDetect.error("Not authorized")

end
