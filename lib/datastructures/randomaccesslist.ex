defmodule DataStructures.RandomAccessList do
  use GenServer

  @type leaf :: {1, any, nil, nil}
  @type tree :: {integer, any, tree | leaf, tree | leaf}
  @type ral :: [tree]

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    start = []
    ins1 = cons({1, :i10, nil, nil}, start)
    ins2 = cons({1, :i9, nil, nil}, ins1)
    ins3 = cons({1, :i8, nil, nil}, ins2)
    ins4 = cons({1, :i7, nil, nil}, ins3)
    ins5 = cons({1, :i6, nil, nil}, ins4)
    ins6 = cons({1, :i5, nil, nil}, ins5)
    ins7 = cons({1, :i4, nil, nil}, ins6)
    ins8 = cons({1, :i3, nil, nil}, ins7)
    ins9 = cons({1, :i2, nil, nil}, ins8)
    ins10 = cons({1, :i1, nil, nil}, ins9)
    {:ok, ins10}
  end



  def insert(value) do
    GenServer.call(__MODULE__, {:insert, value})
  end

  def update(index, value) do
    GenServer.call(__MODULE__, {:update, index, value})
  end

  def display do
    GenServer.call(__MODULE__, :display)
  end

  def convert_to_list do
    GenServer.call(__MODULE__, :convert)
  end



  def handle_call({:insert, value}, _, ral) do
    tree = {1, value, nil, nil}
    newRal = cons(tree, ral)
    {:reply, newRal, newRal}
  end
  def handle_call({:update, index, value}, _, ral) do
    newRal = modify_trees(index, value, ral)
    {:reply, newRal, newRal}
  end
  def handle_call(:display, _, ral) do
    {:reply, ral, ral}
  end
  def handle_call(:convert, _, ral) do
    list = to_list(ral)
    {:reply, list, ral}
  end



  def cons(tree, ral) do
    case ral do
      [] ->
        [tree]
      [{size, value, left, right} | rest] ->
        {treeSize, _, _, _} = tree
        if treeSize == size do
          cons(merge(tree, {size, value, left, right}), rest)
        else
          [tree | ral]
        end
    end
  end

  def merge({size, _, _, _} = left, right), do: {size * 2, nil, left, right}

  def modify_trees(index, value, ral) do
    case ral do
      [] ->
        nil
      [tree | rest] ->
        {size, _, _, _} = tree
        if index < size do
          [modify_tree(index, value, tree) | rest]
        else
          [tree | modify_trees(index - size, value, rest)]
        end
    end
  end

  def modify_tree(index, newValue, {size, rootValue, left, right}) do
    if size == 1 do
      {1, newValue, nil, nil}
    else
      if index < div(size, 2) do # left
        {size, rootValue, modify_tree(index, newValue, left), right}
      else # right
        {size, rootValue, left, modify_tree(index - div(size, 2), newValue, right)}
      end
    end
  end

  def to_list(ral) do
    ral
    |> Enum.reverse()
    |> Enum.map(&to_list_tree/1)
    |> Enum.reduce([], &(&1 ++ &2))
  end

  def to_list_tree(tree) do
    case tree do
      {1, value, nil, nil} ->
        [value]
      {_size, _value, left, right} ->
        to_list_tree(left) ++ to_list_tree(right)
    end
  end
end
