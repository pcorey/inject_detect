defmodule InjectDetect.Command.TurnOnRefill do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.TurnOnRefill do

  alias InjectDetect.Event.TurnedOnRefill
  alias InjectDetect.State.User

  def toggle_refill(user = %{id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%TurnedOnRefill{user_id: user_id}]}
  end

  def toggle_refill(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context, state) do
    User.find(state, command.user_id)
    |> toggle_refill(command, context)
  end

end
