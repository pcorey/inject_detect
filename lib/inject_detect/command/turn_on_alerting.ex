defmodule InjectDetect.Command.TurnOnAlerting do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.TurnOnAlerting do

  alias InjectDetect.Event.TurnedOnAlerting
  alias InjectDetect.State.User

  def toggle_alerting(user = %{id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%TurnedOnAlerting{user_id: user_id}]}
  end

  def toggle_alerting(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context, state) do
    User.find(state, command.user_id)
    |> toggle_alerting(command, context)
  end

end
