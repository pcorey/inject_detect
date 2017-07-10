defmodule InjectDetect.Command.SetStripeToken do
  defstruct user_id: nil,
            stripe_token: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.SetStripeToken do


  alias InjectDetect.Event.SetStripeToken


  def handle(command = %{user_id: user_id}, %{user_id: user_id}, state) do
    {:ok, [%SetStripeToken{user_id: user_id, stripe_token: command.stripe_token}]}
  end
  def handle(_, _, _), do: InjectDetect.error("Not authorized.")


end
