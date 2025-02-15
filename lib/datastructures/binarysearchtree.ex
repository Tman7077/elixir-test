defmodule DataStructures.BinarySearchTree do
  use GenServer

  @tree {
    10,
    {
      5,
      {
        2,
        {1, nil, nil},
        {3, nil, nil}
      },
      {
        7,
        {6, nil, nil},
        {8, nil, nil}
      }
    },
    {
      15,
      {
        12,
        {11, nil, nil},
        {13, nil, nil}
      },
      {
        17,
        {16, nil, nil},
        {18, nil, nil}
      }
    }
  }

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, @tree}
  end



  def search(value) do
    GenServer.call(__MODULE__, {:search, value})
  end

  def lca(root, node1, node2) do
    GenServer.call(__MODULE__, {:lca, root, node1, node2})
  end



  def handle_call({:search, value}, _, tree) do
    result = find_subtree(tree, value)
    {:reply, result, tree}
  end

  def handle_call({:lca, root, node1, node2}, _, tree) do
    result = lowest_common_ancestor(find_subtree(tree, root), node1, node2)
    {:reply, result, tree}
  end



  defp find_subtree(tree, value) do
    case tree do
      nil -> nil
      {node_value, left, right} ->
        if node_value == value do
          {node_value, left, right}
        else
          find_subtree(left, value) || find_subtree(right, value)
        end
    end
  end

  defp lowest_common_ancestor(tree, node1, node2) do
    if find_subtree(tree, node1) == nil || find_subtree(tree, node2) == nil, do: nil
    case tree do
      nil -> nil
      {node_value, left, right} ->
        if node_value == node1 || node_value == node2 do
          node_value
        else
          left_result = lowest_common_ancestor(left, node1, node2)
          right_result = lowest_common_ancestor(right, node1, node2)
          cond do
            left_result != nil && right_result != nil -> node_value
            left_result != nil -> left_result
            right_result != nil -> right_result
            true -> nil
          end
        end
    end
  end
end
