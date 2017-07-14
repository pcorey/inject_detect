defmodule InjectDetect.Command.InvoiceUser do
  defstruct user_id: nil,
            amount: nil,
            ingests_pending_invoice: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.InvoiceUser do

  alias InjectDetect.Event.CreatedInvoiceItem
  alias InjectDetect.State.User


  def handle_create_invoiceitem({:ok, invoiceitem}, user, command) do
    {:ok, [%CreatedInvoiceItem{user_id: user.id,
                               invoiceitem_id: invoiceitem["id"],
                               amount: command.amount,
                               ingests_pending_invoice: command.ingests_pending_invoice}]}
  end


  def handle_create_invoiceitem(error, _user, command) do
    IO.puts("Unable to create invoiceitem: #{inspect error}")
    InjectDetect.error("Unable to create invoiceitem")
  end


  def handle_for_user(nil), do: InjectDetect.error("User not found.")

  def handle_for_user(user, command) do
    Stripe.create_invoiceitem(user.customer_id, command.amount)
    |> handle_create_invoiceitem(user, command)
  end


  def handle(command = %{user_id: user_id}, _context, state) do
    User.find(state, user_id)
    |> handle_for_user(command)
  end

end
