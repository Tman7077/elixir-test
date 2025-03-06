defmodule Patterns.Factory do
  def create_fn(:list) do
    fn x -> Enum.to_list(1..x) end
  end
end
