defmodule InjectDetect.StripeController do
  use InjectDetect.Web, :controller

  alias InjectDetect.Command.LockAccount

  import InjectDetect.CommandHandler, only: [handle: 2]

  def webhook(conn, payload) do
    signature = get_req_header(conn, "stripe-signature")
    secret = System.get_env("STRIPE_SECRET")
    case Stripe.Webhook.construct_event(payload, signature, secret) do
      {:ok, event = %{"type" => "invoice.payment_failed"}} ->
        user = User.find(customer_id: event["data"]["object"]["customer"])
        handle(%LockAccount{user_id: user.id},%{})
        json(conn, %{ok: 200})
      {:ok, event} ->
        json(conn, %{ok: 200})
      {:error, reason} ->
        json(conn, %{error: reason.error})
    end
  end

end
