defmodule InjectDetect.Listener.SendWelcomeEmail do
  use GenServer

  alias InjectDetect.Listener
  alias InjectDetect.Command.SendWelcomeEmail

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Registry.register(Listener.Registry, InjectDetect.Event.GotStarted, [])
  end

  def send_email(user_id, email) do
    %SendWelcomeEmail{user_id: user_id, email: email}
    |> InjectDetect.CommandHandler.handle
  end

  def handle_call({%{user_id: user_id, email: email}, _}, _, _) do
    Task.start(fn -> send_email(user_id, email) end)
    {:reply, :ok, []}
  end

end
