defmodule Processes.Counter do
  def start do
    spawn(fn -> loop(0) end)
  end

  defp loop(count) do
    receive do
      {:increment} ->
        IO.puts("Incrementing")
        loop(count + 1)
      {:decrement} ->
        IO.puts("Decrementing")
        loop(count - 1)
      {:get_count} ->
        IO.puts("Count: #{count}")
        loop(count)
    end
  end
end
