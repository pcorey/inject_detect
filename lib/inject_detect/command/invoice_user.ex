defmodule InjectDetect.Command.InvoiceUser do
  defstruct user_id: nil
end

defimpl InjectDetect.Command, for: InjectDetect.Command.InvoiceUser do

  alias InjectDetect.Event.CreatedInvoiceItem
  alias InjectDetect.State.User


  def handle_create_invoiceitem({:ok, invoiceitem}, user) do
    {:ok, [%CreatedInvoiceItem{user_id: user.id, invoiceitem_id: invoiceitem["id"]}]}
  end


  def handle_create_invoiceitem(error, _error) do
    IO.puts("Unable to create invoiceitem: #{inspect error}")
    InjectDetect.error("Unable to create invoiceitem")
  end


  def handle_for_user(nil), do: InjectDetect.error("User not found.")

  def handle_for_user(user) do
    Stripe.create_invoiceitem(user.customer_id, user.ingests_pending_invoice)
    |> handle_create_invoiceitem(user)
  end


  def handle(%{user_id: user_id}, _context, state) do
    User.find(state, user_id)
    |> handle_for_user
  end

end
