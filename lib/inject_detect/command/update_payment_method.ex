defmodule InjectDetect.Command.UpdatePaymentMethod do
  defstruct user_id: nil,
            stripe_token: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.UpdatePaymentMethod do


  alias InjectDetect.Event.SetStripeToken
  alias InjectDetect.Event.ActivatedAccount
  alias InjectDetect.State.User



  def handle_update_customer({:ok, update}, user = %{active: true}, stripe_token) do
    {:ok, [%SetStripeToken{user_id: user.id, stripe_token: stripe_token}]}
  end

  def handle_update_customer({:ok, update}, user = %{active: false}, stripe_token) do
    {:ok, [%ActivatedAccount{user_id: user.id},
           %SetStripeToken{user_id: user.id, stripe_token: stripe_token}]}
  end

  def handle_update_customer(error, _, _) do
    IO.puts("Unable to update customer: #{inspect error}")
    InjectDetect.error("Unable to update customer.")
  end


  def handle_for_user(nil, _), do: InjectDetect.error("User not found.")

  def handle_for_user(user, stripe_token) do
    Stripe.add_token(user.customer_id, stripe_token.id)
    |> handle_update_customer(user, stripe_token)
  end


  def handle(command = %{user_id: user_id}, %{user_id: user_id}, state) do
    User.find(state, user_id)
    |> handle_for_user(command.stripe_token)
  end

  def handle(_, _, _), do: InjectDetect.error("Not authorized.")


end
