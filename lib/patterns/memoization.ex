defmodule Patterns.Memoization do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(cache), do: {:ok, cache}

  def get_price(product, competitor_price) do
    GenServer.call(__MODULE__, {:get_price, product, competitor_price})
  end

  def handle_call({:get_price, product, competitor_price}, _, cache) do
    case Map.get(cache, product) do
      nil ->
        new_price = competitor_price * 0.9
        new_cache = Map.put(cache, product, new_price)
        {:reply, {"New price:", new_price}, new_cache}
      price ->
        {:reply, {"Remembered price:", price}, cache}
    end
  end
end
