defmodule DataStructures.LeftistMinHeap do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: name) # now that's a lotta names in a row
  end


  def init(name) do
    {:ok, {name, nil}}
  end



  def insert(name, value) do
    GenServer.call(name, {:insert, value})
  end

  def remove_min(name) do
    GenServer.call(name, :remove_min)
  end

  def merge(name1, name2) do
    GenServer.call(name1, {:merge, GenServer.call(name2, :get)})
  end



  def handle_call({:insert, value}, _, {name, heap}) do
    new_heap = insert_value(heap, value)
    {:reply, {:new_root, value(new_heap)}, {name, new_heap}}
  end

  def handle_call(:remove_min, _, {name, heap}) do
    new_heap = remove_root(heap)
    {:reply, {:new_root, value(new_heap)}, {name, new_heap}}
  end

  def handle_call(:get, _, {name, heap}) do
    {:reply, heap, {name, heap}}
  end

  def handle_call({:merge, heap2}, _, {name, heap1}) do
    new_heap1 = merge_heaps(heap1, heap2)
    {:reply, {:new_root, value(new_heap1)}, {name, new_heap1}}
  end



  defp insert_value(nil, value), do: {1, value, nil, nil}
  defp insert_value(heap, value) do
    merge_heaps({1, value, nil, nil}, heap)
  end

  defp merge_heaps(nil, heap), do: heap
  defp merge_heaps(heap, nil), do: heap
  defp merge_heaps(heap1, heap2) do
    {_, value1, left1, right1} = heap1
    {_, value2, left2, right2} = heap2
    if value1 < value2 do
      create_node(value1, left1, merge_heaps(right1, heap2))
    else
      create_node(value2, left2, merge_heaps(right2, heap1))
    end
  end

  def create_node(value, heap1, heap2) do
    if rank(heap1) <= rank(heap2) do
      {rank(heap2) + 1, value, heap1, heap2}
    else
      {rank(heap1) + 1, value, heap2, heap1}
    end
  end

  def remove_root(nil), do: nil
  def remove_root(heap) do
    {_, _, left, right} = heap
    merge_heaps(left, right)
  end



  defp rank(heap) do
    case heap do
      nil -> 0
      {rank, _, _, _} -> rank
    end
  end

  defp value(heap) do
    case heap do
      nil -> 0
      {_, value, _, _} -> value
    end
  end
end
