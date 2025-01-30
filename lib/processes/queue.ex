defmodule Processes.Queue do
  def start do
    spawn(fn -> loop([]) end)
  end

  defp loop(queue) do
    receive do
      {:enqueue, item} ->
        IO.puts("Enqueueing #{item}")
        loop(queue ++ [item])

      {:dequeue} ->
        case queue do
          [] ->
            IO.puts("Queue is empty")
            loop(queue)

          [item | rest] ->
            IO.puts("Dequeueing #{item}")
            loop(rest)
        end

      {:check_queue} ->
        IO.puts("Queue: #{inspect(queue)}")
        loop(queue)
    end
  end
end
