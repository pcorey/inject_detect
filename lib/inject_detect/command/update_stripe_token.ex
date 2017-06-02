defmodule InjectDetect.Command.UpdateStripeToken do
  defstruct user_id: nil,
            stripe_token: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.UpdateStripeToken do


  alias InjectDetect.Event.UpdatedCustomer
  alias InjectDetect.State.User


  def handle_update_customer({:ok, update}, user) do
    IO.puts("update #{inspect update}")
    {:ok, [%UpdatedCustomer{user_id: user.id}]}
  end
  def handle_charge_customer(_, _, _), do: InjectDetect.error("Unable to update customer.")


  def handle_for_user(nil, _), do: InjectDetect.error("User not found.")
  def handle_for_user(user, stripe_token) do
    Stripe.update_customer(user.customer_id, stripe_token.id)
    |> handle_update_customer(user)
  end


  def handle(command = %{user_id: user_id}, %{user_id: user_id}) do
    User.find(user_id)
    |> handle_for_user(command.stripe_token)
  end
  def handle(_, _), do: InjectDetect.error("Not authorized.")


end