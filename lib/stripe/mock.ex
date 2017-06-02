defmodule Stripe.Mock do


  def create_customer(user_id) do
    {:ok, %{"id" => "customer_12345"}}
  end


  def update_customer(customer_id, stripe_token) do
    {:ok, %{"id" => "customer_12345"}}
  end


  def charge_customer(customer_id, amount) do
    {:ok, %{"id" => "charge_12345"}}
  end


  def get_charges(customer_id) do
    {:ok, [%{"id" => "charge_12345"}]}
  end


end
