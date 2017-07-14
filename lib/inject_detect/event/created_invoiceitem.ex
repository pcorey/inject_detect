defmodule InjectDetect.Event.CreatedInvoiceItem do
  defstruct user_id: nil,
            invoiceitem_id: nil,
            amount: nil,
            ingests_pending_invoice: nil
end


defimpl InjectDetect.State.Reducer, for: InjectDetect.Event.CreatedInvoiceItem do


  def apply(event, state) do
    update_in(state, [Lens.key(:users),
                      Lens.filter(&(&1.id == event.user_id)),
                      Lens.key(:ingests_pending_invoice)], &(&1 - event.ingests_pending_invoice))
  end


end
