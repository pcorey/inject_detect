defmodule InjectDetect.Command.SetRefillTrigger do
  defstruct user_id: nil,
            refill_trigger: nil
end

defimpl InjectDetect.Command,
   for: InjectDetect.Command.SetRefillTrigger do

  alias InjectDetect.Event.SetRefillTrigger
  alias InjectDetect.State.User

  def set_refill_trigger(user = %{id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%SetRefillTrigger{user_id: user_id, refill_trigger: command.refill_trigger}]}
  end

  def set_refill_trigger(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context, state) do
    User.find(state, command.user_id)
    |> set_refill_trigger(command, context)
  end

end
