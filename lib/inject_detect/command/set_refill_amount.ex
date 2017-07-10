defmodule InjectDetect.Command.SetRefillAmount do
  defstruct user_id: nil,
            refill_amount: nil
end

defimpl InjectDetect.Command,
   for: InjectDetect.Command.SetRefillAmount do

  alias InjectDetect.Event.SetRefillAmount
  alias InjectDetect.State.User

  def set_refill_amount(user = %{id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%SetRefillAmount{user_id: user_id, refill_amount: command.refill_amount}]}
  end

  def set_refill_amount(_, _, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized",
               message: "Not authorized"}}
  end

  def handle(command, context, state) do
    User.find(state, command.user_id)
    |> set_refill_amount(command, context)
  end

end
