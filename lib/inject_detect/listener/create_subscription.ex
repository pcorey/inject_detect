defmodule InjectDetect.Listener.CreateSubscription do


  alias InjectDetect.Command.CreateSubscription
  alias InjectDetect.Event.CreatedCustomer


  def handle(%CreatedCustomer{user_id: user_id}, context) do
    %CreateSubscription{user_id: user_id}
    |> InjectDetect.CommandHandler.handle(context)
  end

  def handle(_event, _context), do: :ok


end
