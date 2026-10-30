defmodule PokerCalculator.HandRank do
  defstruct [:rank, :kickers]

  @rank_kicker_lengths [
    royal_flush: 0,
    straight_flush: 1,
    four_of_a_kind: 2,
    full_house: 2,
    flush: 5,
    straight: 1,
    three_of_a_kind: 3,
    two_pair: 3,
    pair: 4,
    high_card: 5
  ]
  @ranks Enum.map(@rank_kicker_lengths, fn {rank, _} -> rank end)

  defguardp is_valid_rank_and_kickers(rank, kickers)
            when {rank, length(kickers)} in @rank_kicker_lengths

  def new(rank, kickers) when is_valid_rank_and_kickers(rank, kickers),
    do: %__MODULE__{rank: rank, kickers: kickers}
end
