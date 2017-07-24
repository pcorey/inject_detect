defmodule InjectDetect.Invoicer do
  use GenServer


  alias InjectDetect.Command.InvoiceUser
  alias InjectDetect.CommandHandler

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end


  def init(state) do
    schedule_send_invoices()
    {:ok, state}
  end


  def get_users(state) do
    Lens.key(:users)
    |> Lens.filter(&(&1[:active] && !&1[:locked] && &1[:subscription_id]))
    |> Lens.to_list(state)
  end


  def invoice_user(user = %{ingests_pending_invoice: ingests_pending_invoice}) do
    ingests_per_cent = Application.fetch_env!(:inject_detect, :ingests_per_cent)
    if ingests_pending_invoice > ingests_per_cent do
      amount = div(ingests_pending_invoice, ingests_per_cent)
      %InvoiceUser{user_id: user.id, amount: amount, ingests_pending_invoice: amount * ingests_per_cent}
      |> CommandHandler.handle
    end
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
    invoice_interval = Application.fetch_env!(:inject_detect, :invoice_interval)
    Process.send_after(self(), :send_invoices, invoice_interval)
  end


end
