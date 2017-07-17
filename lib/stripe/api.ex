defmodule Stripe.API do


  @base_url "https://api.stripe.com/v1"


  defp post(route, body) do
    headers = [{"Authorization", "Bearer #{System.get_env("STRIPE_SECRET")}"},
               {"Content-Type", "application/json"}]
    with {:ok, response } <- HTTPoison.post("#{@base_url}/#{route}", {:form, body}, headers) do
      Poison.decode(response.body)
    end
  end

  defp get(route) do
    headers = [{"Authorization", "Bearer #{System.get_env("STRIPE_SECRET")}"},
               {"Content-Type", "application/json"}]
    with {:ok, response } <- HTTPoison.get("#{@base_url}/#{route}", headers) do
      Poison.decode(response.body)
    end
  end


  def create_customer(user_id, email) do
    post("customers", [email: email,
                       account_balance: -1000, # Give the user a $10.00 credit
                       "metadata[user_id]": user_id])
  end


  def create_subscription(customer_id) do
    post("subscriptions", [customer: customer_id, plan: "inject_detect"])
  end


  def create_invoiceitem(customer_id, amount, ingests) do
    # TODO: Store ingested_queries in metadata to count up for given subscription period
    post("invoiceitems", [customer: customer_id,
                          amount: amount,
                          currency: "usd",
                          description: "Ingested queries",
                          "metadata[ingests]": ingests])
  end


  def add_token(customer_id, stripe_token) do
    post("customers/#{customer_id}", [source: stripe_token])
  end


  def add_default_token(customer_id, stripe_token) do
    post("customers/#{customer_id}", [default_source: stripe_token])
  end


  def charge_customer(customer_id, amount) do
    post("charges", [amount: amount, currency: "usd", customer: customer_id])
  end


  def remove_card(customer_id, card_id) do
    post("customers/#{customer_id}/sources/#{card_id}", [])
  end


  def get_subscription(subscription_id) do
    with {:ok, %{"data" => subscription}} <- get("subscriptions/#{subscription_id}"), do: {:ok, subscription}
  end


  def get_invoice(customer_id) do
    with {:ok, %{"data" => [invoice | _]}} <- get("invoices/upcoming?customer=#{customer_id}") do
      {:ok, invoice}
    end
  end


end
