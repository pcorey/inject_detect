defmodule InjectDetect.Command.ConfigureRecurringPayment do
  defstruct user_id: nil,
            refill_amount: nil,
            refill_trigger: nil,
            stripe_token: nil
end


defimpl InjectDetect.Command, for: InjectDetect.Command.ConfigureRecurringPayment do


  alias InjectDetect.Event.SetRefillAmount
  alias InjectDetect.Event.SetRefillTrigger
  alias InjectDetect.Event.TurnedOnRefill
  alias InjectDetect.State.User


  def handle_token({:ok, _}, user, command) do
    {:ok, [%SetRefillAmount{user_id: user.id, refill_amount: command.refill_amount},
           %SetRefillTrigger{user_id: user.id, refill_trigger: command.refill_trigger},
           %TurnedOnRefill{user_id: user.id}]}
  end
  def handle_token(_, _user, _command), do: InjectDetect.error("Unable to set stripe token.")


  def handle_for_user(user = %{id: user_id}, command, %{user_id: user_id}) do
    Stripe.add_default_token(user.customer_id, command.stripe_token.id)
    |> handle_token(user, command)
  end
  def handle_for_user(_, _, _), do: InjectDetect.error("Not authorized.")


  def handle(command, context) do
    User.find(command.user_id)
    |> handle_for_user(command, context)
  end


end
