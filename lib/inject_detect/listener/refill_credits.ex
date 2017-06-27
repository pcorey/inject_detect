defmodule InjectDetect.Listener.RefillCredits do
  require(Logger)

  alias InjectDetect.Command.RefillCredits
  alias InjectDetect.Event.IngestedQuery
  alias InjectDetect.State.User

  def handle_for_user(%{id: user_id,
                        credits: credits,
                        refill_trigger: refill_trigger}) when credits <= refill_trigger do
    %RefillCredits{user_id: user_id}
    |> InjectDetect.CommandHandler.handle
  end
  def handle_for_user(_), do: nil

  def handle(event = %IngestedQuery{}, _context) do
    User.find(event.user_id)
    |> handle_for_user
  end
  def handle(_event, _context), do: :ok

end
