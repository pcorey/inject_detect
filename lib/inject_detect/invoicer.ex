defmodule InjectDetect.Invoicer do
  use GenServer


  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end


  def init(state) do
    schedule_send_invoices()
    {:ok, state}
  end


  def get_users(state) do
    Lens.key(:users)
    |> Lens.filter(&(&1.active && !&1.locked && &1.subscription_id))
    |> Lens.to_list(state)
  end


  def invoice_user(user) do
    IO.puts("invoicing user #{user.id}")
  end


  def send_invoices({:ok, state}) do
    state
    |> get_users
    |> Enum.map(fn user -> Task.start(fn -> invoice_user(user) end) end)
  end


  def send_invoices() do
    InjectDetect.State.get()
    |> send_invoices
  end


  def handle_info(:send_invoices, state) do
    send_invoices()
    schedule_send_invoices()
    {:noreply, state}
  end


  def schedule_send_invoices do
    # Process.send_after(self(), :send_invoices, 1 * 60 * 60 * 1000)
    Process.send_after(self(), :send_invoices, 5 * 1000)
  end


end
