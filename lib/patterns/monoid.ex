defmodule Patterns.Monoid do
  def identity, do: 0
  def operation(a, b), do: a + b
end
