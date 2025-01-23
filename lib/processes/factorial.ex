defmodule Processes.Factorial do
  def start do
    spawn(fn -> loop() end)
  end

  defp loop() do
    receive do
      {:factorial, n} ->
        IO.puts("The factorial of #{n} is #{calculate_factorial(n, 1)}")
        loop()
    end
  end

  defp calculate_factorial(0, result), do: result
  defp calculate_factorial(n, result) do
    calculate_factorial(n - 1, n * result)
  end
end
