defmodule OTP.GenericServers.ExampleChild do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name)
  end

  def init(name) do
    IO.puts("Child server #{name} started")
    {:ok, name}
  end

  def alive(name) do
    GenServer.call(name, :alive)
  end

  def handle_call(:alive, _from, name) do
    {:reply, "#{name} is alive", name}
  end
end
