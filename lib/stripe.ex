defmodule Stripe do

  def create_customer(user_id) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :create_customer, [user_id])
  end

  def charge_customer(customer_id, amount) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :charge_customer, [customer_id, amount])
  end

  def get_charges(customer_id) do
    stripe_module = Application.fetch_env!(:inject_detect, :stripe_module)
    apply(stripe_module, :get_charges, [customer_id])
  end

end
