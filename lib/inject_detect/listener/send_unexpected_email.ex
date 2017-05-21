defmodule InjectDetect.Listener.SendUnexpectedEmail do
  require Logger

  alias InjectDetect.Command.SendUnexpectedEmail
  alias InjectDetect.Event.IngestedUnexpectedQuery
  alias InjectDetect.State.Application

  def send_email(nil, application_id, _query_id) do
    Logger.error("Can't find application \"#{application_id}\" to email unexpected query.")
  end

  def send_email(application, application_id, query_id) do
    %SendUnexpectedEmail{user_id: application.user_id,
                         application_id: application_id,
                         query_id: query_id}
    |> InjectDetect.CommandHandler.handle
  end

  def handle(event = %IngestedUnexpectedQuery{}, _context) do
    Application.find(event.application_id)
    |> send_email(event.application_id, event.id)
  end
  def handle(_event, _context), do: :ok

end
