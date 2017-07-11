defmodule InjectDetect.Listener.CreateCustomer do


  alias InjectDetect.Command.CreateCustomer
  alias InjectDetect.Event.CreatedUser


  def handle(%CreatedUser{user_id: user_id}, context) do
    %CreateCustomer{user_id: user_id}
    |> InjectDetect.CommandHandler.handle(context)
  end

  def handle(_event, _context), do: :ok


end
