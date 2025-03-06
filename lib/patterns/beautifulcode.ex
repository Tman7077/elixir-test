defmodule Patterns.BeautifulCode do
  @whitespace ~r/\s+/
  @operators %{
    "+" => &Kernel.+/2,
    "-" => &Kernel.-/2,
    "*" => &Kernel.*/2,
    "/" => &Kernel.//2
  }
  @type operator :: String.t()

  @spec parse(String.t()) :: number()
  def parse(str) do
    str
    |> String.split(@whitespace)
    |> parse_numbers()
    |> eval()
    |> hd()
    |> maybe_integer()
  end

  @spec parse_numbers(list(String.t())) :: list(number() | operator())
  defp parse_numbers(tokens) do
    Enum.map(tokens, &parse_token/1)
  end

  @spec parse_token(String.t()) :: number() | operator()
  defp parse_token(token) do
    case Float.parse(token) do
      {num, _} -> num
      :error -> token
    end
  end

  @spec eval(list()) :: list()
  defp eval(tokens) do
    Enum.reduce(tokens, [], &process_token/2)
  end

  @spec process_token(number() | operator(), list()) :: list()
  defp process_token(n, stack) when is_number(n), do: [n | stack]
  defp process_token(op, [b, a | rest]) do
    if Map.has_key?(@operators, op) do
      [apply_operator(a, b, op) | rest]
    else
      raise ArgumentError, "Invalid operator: #{op}"
    end
  end

  @spec apply_operator(number(), number(), operator()) :: number()
  defp apply_operator(a, b, op) do
    Map.fetch!(@operators, op).(a, b)
  end

  @spec maybe_integer(number()) :: number()
  defp maybe_integer(num) when num == trunc(num), do: trunc(num)
  defp maybe_integer(num), do: num
end
