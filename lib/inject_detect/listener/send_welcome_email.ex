defmodule InjectDetect.Listener.SendWelcomeEmail do

  alias InjectDetect.Command.SendWelcomeEmail
  alias InjectDetect.Event.GotStarted

  def handle(event = %GotStarted{user_id: user_id, email: email}, _context) do
    %SendWelcomeEmail{user_id: user_id, email: email}
    |> InjectDetect.CommandHandler.handle
  end
  def handle(_event, _context), do: :ok

end
