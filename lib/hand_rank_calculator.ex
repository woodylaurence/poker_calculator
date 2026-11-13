defmodule PokerCalculator.HandRankCalculator do
  alias PokerCalculator.Models.{Card, Hand}
  alias PokerCalculator.HandRank

  def calculate_hand_rank(%Hand{cards: cards}) do
    card_groups = get_multi_card_groups(cards)
    group_counts = Enum.map(card_groups, &elem(&1, 0))

    case group_counts do
      [4 | _] -> get_four_of_a_kind_rank(card_groups)
      _ -> HandRank.new(:high_card, card_groups |> Enum.map(&elem(&1, 1)) |> Enum.take(5))
    end
  end

  def get_multi_card_groups(cards) do
    cards
    |> Enum.frequencies_by(& &1.rank)
    |> Enum.map(fn {rank, count} -> {count, rank} end)
    |> Enum.sort_by(fn {count, rank} -> {count, Card.rank_value(rank)} end, :desc)
  end

  defp get_four_of_a_kind_rank([{4, quads} | other_groups]), do: HandRank.new(:four_of_a_kind, [quads | get_kickers(other_groups, 1)])

  defp get_kickers(remaining_groups, num_to_take) do
    remaining_groups
    |> Enum.map(&elem(&1, 1))
    |> Enum.sort_by(&Card.rank_value/1, :desc)
    |> Enum.take(num_to_take)
  end
end
