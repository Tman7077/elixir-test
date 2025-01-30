defmodule Elix.Processes.Vending_machine do
  def start(inventory) do
    spawn(fn -> loop(inventory, 0) end)
  end

  defp loop(inventory, balance) do
    receive do
      {:add, amount} ->
        IO.puts("Adding #{amount}¢")
        loop(inventory, balance + amount)

      {:get, item} ->
        case Map.get(inventory, item) do
          nil ->
            IO.puts("#{item} not available")
            loop(inventory, balance)

          price ->
            if balance >= price do
              change = balance - price
              IO.puts("Dispensing #{item}. #{change}¢ remaining")
              loop(inventory, change)
            else
              IO.puts("Insufficient balance. Price: #{price}, Current Balance: #{balance}")
              loop(inventory, balance)
            end
        end

        loop(inventory, balance - item)

      {:check_inventory} ->
        Enum.each(inventory, fn {item, price} ->
          IO.puts("#{item}: #{price}")
        end)

        loop(inventory, balance)

      {:dispense_change} ->
        IO.puts("Dispensing #{balance}¢")
        loop(inventory, 0)
    end
  end
end

# this is something that you could enter into the terminal as the inventory
_inventory = %{
  "soda" => 100,
  "chips" => 50,
  "candy" => 25
}
