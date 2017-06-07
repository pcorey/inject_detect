defmodule InjectDetect.Command.AddCredits do
  defstruct user_id: nil,
            credits: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.AddCredits do

  alias InjectDetect.Event.AddedCredits
  alias InjectDetect.State.User

  def add_credits(user = %{id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%AddedCredits{user_id: user_id, credits: command.credits}]}
  end

  def add_credits(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context) do
    User.find(command.user_id)
    |> add_credits(command, context)
  end

end
