defmodule Elix.VarsTupsLists do
  def convert_to_ascii(char) do
    var1 = char
    var2 = var1 |> String.to_charlist() |> hd
    var2
  end

  def get_month(ymd) do
    elem(ymd, 1)
  end

  def get_first_two(list) do
    Enum.take(list, 2)
  end

  def get_third(list) do
    Enum.at(list, 2)
  end
end
