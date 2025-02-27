defmodule Patterns.StatePattern do
  use GenServer

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def init(initial_balance) do
    {:ok, initial_balance}
  end


  def deposit(amount) do
    GenServer.call(__MODULE__, {:deposit, amount})
  end

  def withdraw(amount) do
    GenServer.call(__MODULE__, {:withdraw, amount})
  end

  def get_balance do
    GenServer.call(__MODULE__, :get_balance)
  end


  def handle_call({:deposit, amount}, _from, state) do
    {:reply, :ok, state + amount}
  end

  def handle_call({:withdraw, amount}, _from, state) when state >= amount do
    {:reply, :ok, state - amount}
  end
  def handle_call({:withdraw, _}, _from, state) do
      IO.puts("Insufficient funds.")
      {:reply, :error, state}
  end

  def handle_call(:get_balance, _from, state) do
    {:reply, state, state}
  end
end
