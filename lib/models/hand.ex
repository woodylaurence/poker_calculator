defmodule PokerCalculator.Models.Hand do
  defstruct  [cards: []]

  def new(starting_cards \\ []), do: add_cards(%__MODULE__{}, starting_cards)

  def add_cards(%__MODULE__{cards: cards}, cards_to_add) do
    combined_cards = cards ++ cards_to_add

    cond do
      length(combined_cards) > 7 -> {:error, :hand_cannot_have_more_than_seven_cards}
      has_duplicates?(combined_cards) -> {:error, :hand_cannot_contain_duplicate_cards}
      true -> {:ok, %__MODULE__{cards: combined_cards}}
    end
  end

  defp has_duplicates?(cards), do: length(Enum.uniq(cards)) != length(cards)
end
