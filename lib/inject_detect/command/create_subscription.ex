defmodule InjectDetect.Command.CreateSubscription do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.CreateSubscription do


  alias InjectDetect.Event.CreatedSubscription
  alias InjectDetect.State.User


  def handle_create_subscription({:ok, subscription}, user_id) do
    {:ok, [%CreatedSubscription{user_id: user_id, subscription_id: subscription["id"]}]}
  end

  def handle_create_subscription(_, _), do: InjectDetect.error("Unable to create subscription")


  def create_subscription(nil), do: InjectDetect.error("Can't find user")

  def create_subscription(%{id: user_id, customer_id: customer_id}) do
    Stripe.create_subscription(customer_id)
    |> handle_create_subscription(user_id)
  end


  def handle(%{user_id: user_id}, _context, state) do
    User.find(state, user_id)
    |> create_subscription
  end

end
