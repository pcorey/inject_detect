defmodule InjectDetect.Pricing do

  def amount_for(50_000), do: 500
  def amount_for(100_000), do: 1000
  def amount_for(200_000), do: 2000
  def amount_for(500_000), do: 5000
  def amount_for(1_000_000), do: 10000
  def amount_for(10_000_000), do: 100000

  def amount_for(_), do: {:error, :invalid_credits}

end
