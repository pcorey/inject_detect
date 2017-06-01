defmodule Stripe do

  @base_url "https://api.stripe.com/v1"

  defp post(route, body) do
    headers = [{"Authorization", "Bearer #{System.get_env("STRIPE_SECRET)}"},
               {"Content-Type", "application/json"}]
    with {:ok, response } <- HTTPoison.post("#{@base_url}/#{route}", {:form, body}, headers) do
      Poison.decode(response.body)
    end
  end

  def create_customer(user_id, source) do
    post("customers", [description: user_id, source: source])
  end

  def charge_customer(customer_id, credits, amount) do
    post("charges", [amount: amount, currency: "usd", customer: customer_id])
  end

  def get_charges(customer_id) do
    stripe_secret = System.get_env("STRIPE_SECRET")
    headers = [{"Authorization", "Bearer #{stripe_secret}"}, {"Content-Type", "application/json"}]
    with {:ok, response } <- HTTPoison.get("#{@base_url}/charges?customer=#{customer_id}", headers),
         {:ok, %{"data" => charges}} <- Poison.decode(response.body) do
      {:ok, charges}
    end
  end

end
