defmodule InjectDetect.Listener.SendUnexpectedEmail do
  use GenServer

  alias InjectDetect.Command.SendUnexpectedEmail
  alias InjectDetect.Listener
  alias InjectDetect.State.Application

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Registry.register(Listener.Registry, InjectDetect.Event.IngestedUnexpectedQuery, [])
  end

  def send_email(user_id, application_id, query_id) do
    %SendUnexpectedEmail{user_id: user_id,
                         application_id: application_id,
                         query_id: query_id}
    |> InjectDetect.CommandHandler.handle
  end

  def handle_call({%{application_id: application_id, id: query_id}, _}, _, _) do
    application = Application.find(application_id)
    Task.start(fn -> send_email(application.user_id, application_id, query_id) end)
    {:reply, :ok, []}
  end

end
