defmodule PokerCalculator.HandRankCalculator do
  alias PokerCalculator.Models.{Card,Hand}
  alias PokerCalculator.HandRank

  def calculate_hand_rank(%Hand{cards: cards}) do
    case get_multi_card_groups(cards) do
      high_cards -> HandRank.new(:high_card, high_cards |> Enum.map(&elem(&1, 1)) |> Enum.take(5))
    end
  end

  defp get_multi_card_groups(cards) do
    cards |> Enum.group_by(&(&1.rank))
          |> Enum.map(fn {rank, cards} -> {length(cards), rank} end)
          |> Enum.sort_by(fn {num, rank} -> {num, Card.rank_value(rank)} end, :desc)
  end
end
