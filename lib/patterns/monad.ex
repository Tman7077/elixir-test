defmodule Patterns.Monad do
  def unit(value) do
    case value do
      %{value: _, log: _} ->
        value
      _ ->
        %{value: value, log: []}
    end
  end

  def bind(%{value: val, log: log}, f) do
    newVal = f.(val)
    newLog = ["#{inspect(val)} -> #{inspect(newVal)}" | log]
    %{value: newVal, log: newLog}
  end

  def modifyNumber(value) do
    value * 3 + 2
  end
end
