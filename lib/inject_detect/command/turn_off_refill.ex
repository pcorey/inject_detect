defmodule InjectDetect.Command.TurnOffRefill do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.TurnOffRefill do

  alias InjectDetect.Event.TurnedOffRefill
  alias InjectDetect.State.User

  def toggle_refill(user = %{id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%TurnedOffRefill{user_id: user_id}]}
  end

  def toggle_refill(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context) do
    User.find(command.user_id)
    |> toggle_refill(command, context)
  end

end
