defmodule Patterns.Functor do
  def fmap({one, two}, f) do
    newTwo = f.(two)
    {one, newTwo}
  end
end
