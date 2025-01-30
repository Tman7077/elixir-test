defmodule Elix.Functions.Palindrome do
  def check(word) do
    word == String.reverse(word)
  end
end
