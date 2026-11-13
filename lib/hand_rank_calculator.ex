defmodule PokerCalculator.HandRankCalculator do
  alias PokerCalculator.Models.{Card, Hand}
  alias PokerCalculator.HandRank

  def calculate_hand_rank(%Hand{cards: cards}) do
    card_groups = get_multi_card_groups(cards)
    group_counts = Enum.map(card_groups, &elem(&1, 0))

    case group_counts do
      [4 | _] -> get_four_of_a_kind_rank(card_groups)
      [3, n | _] when n >= 2 -> get_full_house_rank(card_groups)
      [3 | _] -> get_three_of_a_kind_rank(card_groups)
      [2, 2 | _] -> get_two_pair_rank(card_groups)
      [2  | _] -> get_pair_rank(card_groups)
      _ -> HandRank.new(:high_card, card_groups |> Enum.map(&elem(&1, 1)) |> Enum.take(5))
    end
  end

  def get_multi_card_groups(cards) do
    cards
    |> Enum.frequencies_by(& &1.rank)
    |> Enum.map(fn {rank, count} -> {count, rank} end)
    |> Enum.sort_by(fn {count, rank} -> {count, Card.rank_value(rank)} end, :desc)
  end

  defp get_four_of_a_kind_rank([{4, quad_rank} | tail]), do: HandRank.new(:four_of_a_kind, [quad_rank | get_kickers(tail, 1)])

  defp get_full_house_rank([{3, triple_rank}, {_, second_rank} | _]), do: HandRank.new(:full_house, [triple_rank, second_rank])

  defp get_three_of_a_kind_rank([{3, triple_rank} | tail]), do: HandRank.new(:three_of_a_kind, [triple_rank | get_kickers(tail, 2)])

  defp get_two_pair_rank([{2, higher_pair_rank}, {2, lower_pair_rank} | tail]), do: HandRank.new(:two_pair, [higher_pair_rank, lower_pair_rank | get_kickers(tail, 1)])

  defp get_pair_rank([{2, pair_rank} | tail]), do: HandRank.new(:pair, [pair_rank | get_kickers(tail, 3)])

  defp get_kickers(remaining_groups, num_to_take) do
    remaining_groups
    |> Enum.map(&elem(&1, 1))
    |> Enum.sort_by(&Card.rank_value/1, :desc)
    |> Enum.take(num_to_take)
  end
end
