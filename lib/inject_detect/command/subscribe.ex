defmodule InjectDetect.Command.Subscribe do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.Subscribe do

  alias InjectDetect.Event.Subscribed
  alias InjectDetect.State.User

  def subscribe(user = %{id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%Subscribed{user_id: user_id}]}
  end

  def subscribe(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context, state) do
    User.find(state, command.user_id)
    |> subscribe(command, context)
  end

end
