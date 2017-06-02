defmodule Stripe.API do


  @base_url "https://api.stripe.com/v1"


  defp post(route, body) do
    headers = [{"Authorization", "Bearer #{System.get_env("STRIPE_SECRET")}"},
               {"Content-Type", "application/json"}]
    with {:ok, response } <- HTTPoison.post("#{@base_url}/#{route}", {:form, body}, headers) do
      Poison.decode(response.body)
    end
  end


  def create_customer(user_id) do
    post("customers", [description: user_id])
  end


  def update_customer(customer_id, stripe_token) do
    post("customers/#{customer_id}", [default_source: stripe_token])
  end


  def charge_customer(customer_id, amount) do
    post("charges", [amount: amount, currency: "usd", customer: customer_id])
  end


end
