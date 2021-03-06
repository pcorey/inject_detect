defmodule Stripe do


  def create_customer(user_id, email) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :create_customer, [user_id, email])
  end


  def create_subscription(customer_id) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :create_subscription, [customer_id])
  end


  def add_default_token(user_id, stripe_token_id) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :add_default_token, [user_id, stripe_token_id])
  end


  def add_token(user_id, stripe_token_id) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :add_token, [user_id, stripe_token_id])
  end


  def charge_customer(customer_id, amount) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :charge_customer, [customer_id, amount])
  end


  def get_subscription(subscription_id) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :get_subscription, [subscription_id])
  end


  def get_invoice(customer_id) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :get_invoice, [customer_id])
  end


  def create_invoiceitem(customer_id, amount, ingests) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :create_invoiceitem, [customer_id, amount, ingests])
  end


end
