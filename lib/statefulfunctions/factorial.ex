defmodule StatefulFunctions.Factorial do
  def calculate(n) do
    do_factorial(n, 1)
  end

  defp do_factorial(0, prev), do: prev
  defp do_factorial(n, prev) do
    do_factorial(n - 1, n * prev)
  end
end
