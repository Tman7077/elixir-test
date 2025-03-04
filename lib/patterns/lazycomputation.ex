defmodule Patterns.LazyComputation do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(val), do: {:ok, val}

  def next_sq do
    GenServer.call(__MODULE__, :next_sq)
  end

  def handle_call(:next_sq, _, val), do: {:reply, (val + 1) ** 2, val + 1}
end
