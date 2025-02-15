defmodule DataStructures.Deque do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, {[], []}}
  end

  def enqueue_front(element) do
    GenServer.cast(__MODULE__, {:enqueue_front, element})
  end

  def enqueue_rear(element) do
    GenServer.cast(__MODULE__, {:enqueue_rear, element})
  end

  def dequeue_front do
    GenServer.call(__MODULE__, :dequeue_front)
  end

  def dequeue_rear do
    GenServer.call(__MODULE__, :dequeue_rear)
  end

  def check_empty do
    GenServer.call(__MODULE__, :check_empty)
  end



  def handle_cast({:enqueue_front, element}, {front, rear}) do
    {:noreply, {[element | front], rear}}
  end

  def handle_cast({:enqueue_rear, element}, {front, rear}) do
    {:noreply, {front, [element | rear]}}
  end

  def handle_call(:dequeue_front, _, {front, rear}) do
    case front do
      [] ->
        rear_reversed = Enum.reverse(rear)
        {element, new_front} = List.pop_at(rear_reversed, 0)
        {:reply, element, {new_front, []}}
      [element | new_front] ->
        {:reply, element, {new_front, rear}}
    end
  end

  def handle_call(:dequeue_rear, _, {front, rear}) do
    case rear do
      [] ->
        front_reversed = Enum.reverse(front)
        {element, new_rear} = List.pop_at(front_reversed, 0)
        {:reply, element, {[], new_rear}}
      [element | new_rear] ->
        {:reply, element, {front, new_rear}}
    end
  end

  def handle_call(:check_empty, _, {front, rear}) do
    case {front, rear} do
      {[], []} ->
        {:reply, :yes, {front, rear}}
      _ ->
        {:reply, :no, {front, rear}}
    end
  end
end
