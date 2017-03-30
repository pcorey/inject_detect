defmodule InjectDetect.Listener.EmailToken do
  use GenServer

  require Logger

  alias InjectDetect.Listener
  alias InjectDetect.State

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    Registry.register(Listener.Registry,
                      InjectDetect.Event.RequestedSignInToken,
                      [])
  end

  def handle_call({%{requested_token: requested_token},
                   %{user_id: user_id}}, _, _) do
    case user = State.user(:id, user_id) do
      nil  -> Logger.info("Can't find user #{user_id} to email token.")
      user -> Logger.info("Requested token: #{requested_token}")
    end
    {:reply, :ok, []}
  end
end
