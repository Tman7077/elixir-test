defmodule OTP.GenericServers.Store do
  use GenServer

  @example_inventory %{
    :apple => 3,
    :banana => 2,
    :strawberry => 1
  }

  def start_link(initial_inventory \\ @example_inventory) do
    GenServer.start_link(__MODULE__, initial_inventory, name: __MODULE__)
  end

  # Public API
  def stock(item, amount) do
    GenServer.call(__MODULE__, {:stock, item, amount})
  end

  def check_stock(item) do
    GenServer.call(__MODULE__, {:check_stock, item})
  end

  def sell(item) do
    GenServer.call(__MODULE__, {:sell, item})
  end

  # Private handlers
  def init(initial_inventory) do
    {:ok, initial_inventory}
  end

  def handle_call({:stock, item, amount}, _from, inventory) do
    {:reply, :ok, Map.update(inventory, item, amount, &(&1 + amount))}
  end

  def handle_call({:check_stock, item}, _from, inventory) do
    {:reply, Map.get(inventory, item), inventory}
  end

  def handle_call({:sell, item}, _from, inventory) do
    if inventory[item] == nil or
         inventory[item] == 0 do
      IO.puts("No #{item} in stock.")
      {:reply, :error, inventory}
    else
      {:reply, :ok, Map.update!(inventory, item, &(&1 - 1))}
    end
  end
end
