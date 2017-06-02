defmodule InjectDetect.Command.ConfigureRefill do
  defstruct user_id: nil,
            refill_amount: nil,
            refill_trigger: nil
end


defimpl InjectDetect.Command, for: InjectDetect.Command.ConfigureRefill do


  alias InjectDetect.Event.SetRefillAmount
  alias InjectDetect.Event.SetRefillTrigger
  alias InjectDetect.Event.TurnOnRefill
  alias InjectDetect.State.User


  def set_refill_amount(user = %{id: user_id}, command, %{user_id: user_id}) do
    {:ok, [%SetRefillAmount{user_id: user_id, refill_amount: command.refill_amount},
           %SetRefillTrigger{user_id: user_id, refill_trigger: command.refill_trigger},
           %TurnOnRefill{user_id: user_id}]}
  end
  def set_refill_amount(_, _, _), do: InjectDetect.error("Not authorized.")


  def handle(command, context) do
    User.find(command.user_id)
    |> set_refill_amount(command, context)
  end


end
