defmodule Stripe do

  @base_url "https://api.stripe.com/v1"

  def create_customer(user_id, source) do
    stripe_secret = System.get_env("STRIPE_SECRET")
    body = {:form, [description: user_id, source: source]}
    headers = [{"Authorization", "Bearer #{stripe_secret}"}, {"Content-Type", "application/json"}]
    with {:ok, response } <- HTTPoison.post("#{@base_url}/customers", body, headers) do
      Poison.decode(response.body)
    end
  end

  def charge_customer(customer_id, credits, amount) do
    stripe_secret = System.get_env("STRIPE_SECRET")
    body = {:form, [amount: amount,
                    currency: "usd",
                    description: "Charge for #{credits} credits",
                    customer: customer_id]}
    headers = [{"Authorization", "Bearer #{stripe_secret}"}, {"Content-Type", "application/json"}]
    with {:ok, response } <- HTTPoison.post("#{@base_url}/charges", body, headers) do
      Poison.decode(response.body)
    end
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
