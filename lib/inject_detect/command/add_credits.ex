defmodule InjectDetect.Command.AddCredits do
  defstruct user_id: nil,
            credits: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.AddCredits do

  alias InjectDetect.Event.AddedCredits
  alias InjectDetect.State.User

  def toggle_refill(user = %{id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%AddedCredits{user_id: user_id, credits: command.credits}]}
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
