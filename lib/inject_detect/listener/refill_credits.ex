defmodule InjectDetect.Listener.RefillCredits do
  require(Logger)

  alias InjectDetect.Command.RefillCredits
  alias InjectDetect.Event.IngestedQuery
  alias InjectDetect.State.Application

  def send_email(nil, application_id, _query_id) do
    Logger.error("Can't find application \"#{application_id}\" to email unexpected query.")
  end

  def handle_for_application(%{user_id: user_id,
                               credits: credits,
                               refill_trigger: refill_trigger}) when credits < refill_trigger do
    %RefillCredits{user_id: user_id}
    |> InjectDetect.CommandHandler.handle
  end
  def handle_for_application(_), do: nil

  def handle(event = %IngestedQuery{}, _context) do
    Application.find(event.application_id)
    |> handle_for_application
  end
  def handle(_event, _context), do: :ok

end
