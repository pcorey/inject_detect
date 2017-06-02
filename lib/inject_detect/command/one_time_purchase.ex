defmodule InjectDetect.Command.OneTimePurchase do
  defstruct user_id: nil,
            credits: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.OneTimePurchase do


  alias InjectDetect.Event.AddedCredits
  alias InjectDetect.Event.ChargedCustomer
  alias InjectDetect.Pricing
  alias InjectDetect.State.User


  def handle_charge_customer({:ok, charge}, user, credits, amount) do
    IO.puts("charge #{inspect charge}")
    {:ok, [%ChargedCustomer{user_id: user.id, charge_id: charge["id"]},
           %AddedCredits{user_id: user.id, credits: credits}]}
  end
  def handle_charge_customer(_, _, _), do: InjectDetect.error("Unable to charge customer.")


  def handle_for_user(nil, _), do: InjectDetect.error("User not found.")
  def handle_for_user(user, credits) do
    Stripe.charge_customer(user.customer_id, Pricing.amount_for(credits))
    |> handle_charge_customer(user, credits, Pricing.amount_for(credits))
  end


  def handle(command = %{user_id: user_id}, %{user_id: user_id}) do
    User.find(user_id)
    |> handle_for_user(command.credits)
  end
  def handle(_, _), do: InjectDetect.error("Not authorized.")


end
