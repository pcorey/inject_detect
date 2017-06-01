defmodule InjectDetect.Command.OneTimePurchase do
  defstruct user_id: nil,
            credits: nil,
            stripe_token: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.OneTimePurchase do

  alias InjectDetect.Event.AddedCredits
  alias InjectDetect.Event.ChargedCustomer
  alias InjectDetect.Event.CreatedCustomer
  alias InjectDetect.State.User

  def handle_charge_customer({:ok, charge}, customer, user_id, credits, amount) do
    IO.puts("charge #{inspect charge}")
    {:ok, [%CreatedCustomer{user_id: user_id, customer_id: customer["id"]},
           %ChargedCustomer{user_id: user_id, charge_id: charge["id"]},
           %AddedCredits{user_id: user_id, credits: credits}]}
  end
  def handle_charge_customer(_, _, _), do: {:error, %{code: :unable_to_charge_customer,
                                                      error: "Unable to charge customer.",
                                                      message: "Unable to charge customer."}}

  def handle_create_customer({:ok, customer}, user_id, credits) do
    amount = credits
    Stripe.charge_customer(customer["id"], credits, amount)
    |> handle_charge_customer(customer, user_id, credits, amount)
  end
  def handle_create_customer(_, _, _), do: {:error, %{code: :unable_to_create_customer,
                                                      error: "Unable to create customer.",
                                                      message: "Unable to create customer."}}

  def handle(command = %{user_id: user_id}, %{user_id: user_id}) do
    Stripe.create_customer(user_id, command.stripe_token.id)
    |> handle_create_customer(user_id, command.credits)
  end

  def handle(_, _) do
    {:error, %{code: :not_authorized,
               error: "Not authorized.",
               message: "Not authorized."}}
  end

end
