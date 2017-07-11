defmodule InjectDetect.Command.CreateCustomer do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.CreateCustomer do


  alias InjectDetect.Event.CreatedCustomer
  alias InjectDetect.State.User


  def handle_create_customer({:ok, customer}, user_id) do
    {:ok, [%CreatedCustomer{user_id: user_id, customer_id: customer["id"]}]}
  end

  def handle_create_customer(_, _), do: InjectDetect.error("Unable to create customer")


  def create_customer(nil), do: InjectDetect.error("Can't find user")

  def create_customer(%{id: user_id, email: email}) do
    Stripe.create_customer(user_id, email)
    |> handle_create_customer(user_id)
  end


  def handle(%{user_id: user_id}, _context, state) do
    User.find(state, user_id)
    |> create_customer
  end

end
