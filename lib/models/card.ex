defmodule PokerCalculator.Models.Card do
  defstruct [:rank, :suit]

  @ranks_and_values [ace: 14, king: 13, queen: 12, jack: 11, ten: 10, nine: 9, eight: 8, seven: 7, six: 6, five: 5, four: 4, three: 3, two: 2]
  @values_and_ranks Map.new(@ranks_and_values, fn {rank, value} -> {value, rank} end)

  @ranks Keyword.keys(@ranks_and_values)
  @suits [:spades, :hearts, :diamonds, :clubs]

  def new(rank, suit) when rank in @ranks and suit in @suits do
    %__MODULE__{rank: rank, suit: suit}
  end

  def ranks, do: @ranks
  def suits, do: @suits

  def rank_value(%__MODULE__{rank: rank}), do: Keyword.fetch!(@ranks_and_values, rank)
  def rank_value(rank) when rank in @ranks, do: Keyword.fetch!(@ranks_and_values, rank)

  def value_rank(nil), do: nil
  def value_rank(value), do: Map.fetch!(@values_and_ranks, value)
end
