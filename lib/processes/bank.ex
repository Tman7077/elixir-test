defmodule Processes.Bank do
  def start do
    spawn(fn -> loop(0) end)
  end

  defp loop(balance) do
    receive do
      {:deposit, amount} ->
        IO.puts("Depositing $#{amount}")
        loop(balance + amount)

      {:withdraw, amount} ->
        case amount > balance do
          true ->
            IO.puts("Insufficient funds")
            loop(balance)

          false ->
            IO.puts("Withdrawing $#{amount}")
            loop(balance - amount)
        end

      {:get_balance} ->
        IO.puts("Balance: $#{balance}")
        loop(balance)
    end
  end
end
