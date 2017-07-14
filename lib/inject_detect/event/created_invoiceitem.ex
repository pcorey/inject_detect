defmodule InjectDetect.Event.CreatedInvoiceItem do
  defstruct user_id: nil,
            invoiceitem_id: nil
end


defimpl InjectDetect.State.Reducer, for: InjectDetect.Event.CreatedInvoiceItem do


  def apply(event, state) do
    put_in(state, [Lens.key(:users),
                   Lens.filter(&(&1.id == event.user_id)),
                   Lens.key(:ingests_pending_invoice)], 0)
  end


end
