defmodule InjectDetect.Command.RefillCredits do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.RefillCredits do


  alias InjectDetect.Event.AddedCredits
  alias InjectDetect.Event.ChargeFailed
  alias InjectDetect.Event.ChargedCustomer
  alias InjectDetect.Pricing
  alias InjectDetect.State.User


  def handle_charge_customer({:ok, charge}, user, credits, amount) do
    {:ok, [%ChargedCustomer{user_id: user.id, charge_id: charge["id"]},
           %AddedCredits{user_id: user.id, credits: credits}]}
  end
  def handle_charge_customer(response, user, _, _) do
    {:ok, [%ChargeFailed{user_id: user.id, response: response}]}
  end
  def handle_charge_customer(_, _, _, _) do
    InjectDetect.error("Unable to charge customer.")
  end


  def handle_for_user(nil), do: InjectDetect.error("User not found.")
  def handle_for_user(user) do
    Stripe.charge_customer(user.customer_id, Pricing.amount_for(user.refill_amount))
    |> handle_charge_customer(user, user.refill_amount, Pricing.amount_for(user.refill_amount))
  end


  def handle(command = %{user_id: user_id}, _, state) do
    User.find(state, user_id)
    |> handle_for_user
  end
  def handle(_, _), do: InjectDetect.error("Not authorized.")


end
