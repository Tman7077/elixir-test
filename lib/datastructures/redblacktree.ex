defmodule DataStructures.RedBlackTree do
    use GenServer

    @tree {
        :black, 8,
        {
            :black, 5,
            nil,
            nil
        },
        {
            :red, 15,
            {
                :black, 12,
                {
                    :red, 9,
                    nil,
                    nil
                },
                {
                    :red, 13,
                    nil,
                    nil
                }
            },
            {
                :black, 19,
                nil,
                {
                    :red, 23,
                    nil,
                    nil
                }
            }
        }
    }
    @moduledoc """
    @result {
        :black, 10,
        {
            :black, 8,
            {:black, 5, nil, nil},
            {:black, 9, nil, nil}},
        {
            :black, 15,
            {
                :black, 12, nil,
                {:red, 13, nil, nil}},
            {
                :black, 19, nil,
                {:red, 23, nil, nil}
            }
        }
    } # order is right, coloring is valid
    # it feels like there's a lot of black, but the root is black, black depth is consistent, and no red nodes have red children soooo
    """

    def start_link do
        GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    end

    def init(:ok) do
        {:ok, @tree}
    end

    def insert(value) do
        GenServer.call(__MODULE__, {:insert, value})
    end

    def handle_call({:insert, value}, _, tree) do
        newTree = ensure_black_root(insert_helper(tree, value))
        {:reply, newTree, newTree}
    end

    defp insert_helper(nil, insertValue), do: {:red, insertValue, nil, nil}
    defp insert_helper(tree, insertValue) do
        {color, value, left, right} = tree
        if insertValue < value do
            balance({color, value, insert_helper(left, insertValue), right})
        else
            balance({color, value, left, insert_helper(right, insertValue)}) # bruh
        end
    end

    defp ensure_black_root({:red, value, left, right}), do: {:black, value, left, right}
    defp ensure_black_root(tree), do: tree

    defp balance({:black, z, {:red, y, {:red, x, a, b}, c}, d}) do
      {:red, y, {:black, x, a, b}, {:black, z, c, d}}
    end
    defp balance({:black, z, {:red, x, a, {:red, y, b, c}}, d}) do
      {:red, y, {:black, x, a, b}, {:black, z, c, d}}
    end
    defp balance({:black, x, a, {:red, z, {:red, y, b, c}, d}}) do
      {:red, y, {:black, x, a, b}, {:black, z, c, d}}
    end
    defp balance({:black, x, a, {:red, y, b, {:red, z, c, d}}}) do
      {:red, y, {:black, x, a, b}, {:black, z, c, d}}
    end
    defp balance(node), do: node
end
