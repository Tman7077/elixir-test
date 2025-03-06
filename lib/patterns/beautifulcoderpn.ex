defmodule Patterns.BeautifulCodeRPN do
  @operator ~r/([\+\-\*\/])/
  @precedence %{"+" => 1, "-" => 1, "*" => 2, "/" => 2}

  def parse(str) do
    whitespace = ~r/\s+/
    str
    |> String.replace(whitespace, "")
    |> String.split(@operator, include_captures: true)
    |> parse_nums()
    |> to_rpn()
    |> eval()
  end

  defp parse_nums(list) do
    Enum.map(list, fn x ->
      case Integer.parse(x) do
        {num, _} -> num
        :error -> x
      end
    end)
  end

  def to_rpn(tokens) do
    {output, stack} =
      Enum.reduce(tokens, {[], []}, fn token, {output, stack} ->
        cond do
          is_number(token) ->
            {output ++ [token], stack}

          token in Map.keys(@precedence) ->
            {new_output, new_stack} = pop_ops(token, output, stack)
            {new_output, [token | new_stack]}  # Push operator on the head
        end
      end)

    # Append the operator stack as is, since the head is the top
    output ++ stack
  end

  # Pop operators while they have higher or equal precedence than the current operator.
  defp pop_ops(op, output, [top | rest]) when is_binary(top) do
    if precedence(top) >= precedence(op) do
      pop_ops(op, output ++ [top], rest)
    else
      {output, [top | rest]}
    end
  end
  defp pop_ops(_op, output, stack), do: {output, stack}

  defp precedence(op), do: Map.get(@precedence, op, 0)

  def eval(tokens) do
    tokens
    |> Enum.reduce([], fn token, stack ->
      case token do
        n when is_number(n) ->
          # Push the number onto the stack
          [n | stack]
        op when op in ["+", "-", "*", "/"] ->
          # Pop two numbers from the stack, apply the operator, and push the result
          [b, a | rest] = stack
          result = apply_op(a, b, op)
          [result | rest]
      end
    end)
    |> hd()  # At the end, the stack should have one element—the result
  end

  defp apply_op(a, b, "+"), do: a + b
  defp apply_op(a, b, "-"), do: a - b
  defp apply_op(a, b, "*"), do: a * b
  defp apply_op(a, b, "/"), do: a / b
end
