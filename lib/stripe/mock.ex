defmodule Stripe.Mock do


  def create_customer(user_id, email) do
    {:ok, %{"id" => "customer_12345"}}
  end


  def create_subscription(customer_id) do
    {:ok, %{"id" => "subscription_12345"}}
  end


  def create_invoiceitem(customer_id, amount, ingests) do
    {:ok, %{"id" => "invoiceitem_12345"}}
  end


  def add_default_token(customer_id, stripe_token) do
    {:ok, %{"id" => "customer_12345"}}
  end

  def add_token(customer_id, stripe_token) do
    {:ok, %{"id" => "customer_12345"}}
  end


  def charge_customer(customer_id, amount) do
    {:ok, %{"id" => "charge_12345"}}
  end


  def get_subscription(subscription_id) do
    {:ok, [%{"id" => "subscription_12345"}]}
  end


  def get_invoice(customer_id) do
    {:ok, [%{"id" => "invoice_12345"}]}
  end


end
