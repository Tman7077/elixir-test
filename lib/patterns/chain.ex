defmodule Patterns.Chain do
  @spec cleanup(String.t()) :: String.t()
  def cleanup(str) do
    str
    |> String.trim()
    |> String.downcase()
    |> String.replace(~r/\s/, "_")
  end

  @spec sqSum(list(integer())) :: integer()
  def sqSum(list) do
    list
    |> Enum.map(&(&1 * &1))
    |> Enum.sum()
  end

  @spec roundStringAppend(list(float())) :: String.t()
  def roundStringAppend(list) do
    list
    |> Enum.map(&(round(&1)))
    |> Enum.map(&(Integer.to_string(&1)))
    |> Enum.join()
    |> (&(&1 <> "_suffix")).()
  end

  @spec sentenceLessFour(list(String.t())) :: String.t()
  def sentenceLessFour(list) do
    list
    |> Enum.filter(&(String.length(&1) <= 4))
    |> Enum.join(" ")
  end
end
