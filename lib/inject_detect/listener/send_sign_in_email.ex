defmodule InjectDetect.Listener.SendSignInEmail do
  use GenServer

  require Logger

  alias InjectDetect.Command.SendSignInEmail
  alias InjectDetect.Listener
  alias InjectDetect.State.User

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Registry.register(Listener.Registry, InjectDetect.Event.RequestedSignInToken, [])
  end

  def send_email(user_id, requested_token, email) do
    %SendSignInEmail{user_id: user_id, requested_token: requested_token, email: email}
    |> InjectDetect.CommandHandler.handle
  end

  def handle_call({%{requested_token: requested_token, user_id: user_id}, _}, _, _) do
    case User.find(user_id) do
      nil  -> Logger.error("Can't find user #{user_id} to email token.")
      user -> Task.start(fn -> send_email(user_id, requested_token, user.email) end)
    end
    {:reply, :ok, []}
  end

end
