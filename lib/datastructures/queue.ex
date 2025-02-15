defmodule DataStructures.Queue do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, {[], []}}
  end

  def enqueue(element) do
    GenServer.cast(__MODULE__, {:enqueue, element})
  end

  def dequeue do
    GenServer.call(__MODULE__, :dequeue)
  end

  def check_empty do
    GenServer.call(__MODULE__, :check_empty)
  end

  def handle_cast({:enqueue, element}, {front, rear}) do
    {:noreply, {front, [element|rear]}}
  end

  def handle_call(:dequeue, _, {front, rear}) do
    case front do
      [] ->
        rear_reversed = Enum.reverse(rear)
        {element, new_front} = List.pop_at(rear_reversed, 0) # so this returns {2, 3} instead of {2, [3]}?
        {:reply, element, {new_front, []}} # nope
      [element|new_front] -> # that was a dumb mistake
        {:reply, element, {new_front, rear}}
    end
  end

  def handle_call(:check_empty, _, {front, back}) do
    case {front, back} do
      {[], []} ->
        {:reply, :yes, {front, back}}
      _ ->
        {:reply, :no, {front, back}}
    end
  end
end
