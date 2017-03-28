defmodule InjectDetect.User.Listener do
  use GenServer

  alias InjectDetect.Listener

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    Registry.register(Listener.Registry, :requested_sign_in_link, __MODULE__)
  end

  def handle_call({:requested_sign_in_link, user_id, %{email: email}}, _, _) do
    unless user = State.find_user(:email, email) do
      IO.puts("Requested login token \"#{user.requested_token}\"")
    end
    {:noreply, []}
  end

end
