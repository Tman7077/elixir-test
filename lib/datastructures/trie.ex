defmodule DataStructures.Trie do
  defstruct children: %{}, is_end: false

  alias DataStructures.Trie, as: Trie

  def new(), do: %Trie{}

  def empty?(%Trie{children: children, is_end: is_end}) do
    map_size(children) == 0 and not is_end
  end

  def add(%Trie{} = trie, ""), do: %{trie | is_end: true}
  def add(%Trie{children: children} = trie, <<char::utf8, rest::binary>>) do
    char_key = <<char>>
    child = Map.get(children, char_key, %Trie{})
    updated_child = add(child, rest)
    %{trie | children: Map.put(children, char_key, updated_child)}
  end

  def contains?(%Trie{is_end: true}, ""), do: true
  def contains?(%Trie{}, ""), do: false
  def contains?(%Trie{children: children}, <<char::utf8, rest::binary>>) do
    char_key = <<char>>
    case Map.get(children, char_key) do
      nil -> false
      child -> contains?(child, rest)
    end
  end

  def remove(%Trie{} = trie, ""), do: %{trie | is_end: false}
  def remove(%Trie{children: children} = trie, <<char::utf8, rest::binary>>) do
    char_key = <<char>>
    case Map.get(children, char_key) do
      nil ->
        trie
      child ->
        updated_child = remove(child, rest)
        updated_children =
          if empty?(updated_child) do
            Map.delete(children, char_key)
          else
            Map.put(children, char_key, updated_child)
          end
        %{trie | children: updated_children}
    end
  end

  def prefix(%Trie{} = trie, prefix) do
    case find_node(trie, prefix) do
      nil ->
        []
      node ->
        collect_words(node, "")
        |> Enum.map(fn suffix -> prefix <> suffix end)
    end
  end

  def toList(%Trie{} = trie) do
    collect_words(trie, "")
  end

  def fromList(list) do
    Enum.reduce(list, new(), fn word, trie ->
      add(trie, word)
    end)
  end

  ###

  defp find_node(%Trie{} = trie, ""), do: trie
  defp find_node(%Trie{children: children}, <<char::utf8, rest::binary>>) do
    char_key = <<char>>
    case Map.get(children, char_key) do
      nil -> nil
      node -> find_node(node, rest)
    end
  end

  defp collect_words(%Trie{children: children, is_end: is_end}, prefix) do
    current = if is_end, do: [prefix], else: []
    children_words =
      children
      |> Enum.flat_map(fn {char, child} ->
        collect_words(child, prefix <> char)
      end)
    current ++ children_words
  end
end
