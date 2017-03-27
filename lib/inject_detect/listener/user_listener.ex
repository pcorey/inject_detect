defmodule InjectDetect.Listener.UserListener do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def notify(event) do
    GenServer.call(__MODULE__, {:on, event})
  end

  def handle_call({:on, {:requested_new_token}}, _, _) do
    IO.puts("Requested new token...")
    {:reply, :ok, :ok}
  end

  def handle_call(_, _, _), do: {:reply, :ok, :ok}
end
