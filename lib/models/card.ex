defmodule PokerCalculator.Models.Card do
  defstruct [:rank, :suit]

  @ranks [:ace, :king, :queen, :jack, :ten, :nine, :eight, :seven, :six, :five, :four, :three, :two]
  @suits [:spades, :hearts, :diamonds, :clubs]

  def new(rank, suit) when rank in @ranks and suit in @suits do
    %__MODULE__{rank: rank, suit: suit}
  end

  def ranks, do: @ranks
  def suits, do: @suits
end
