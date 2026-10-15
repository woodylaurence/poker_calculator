defmodule PokerCalculator.Models.Deck do
  alias PokerCalculator.Models.Card

  defstruct [:cards]

  def new() do
    cards = for rank <- Card.ranks(), suit <- Card.suits(), do: Card.new(rank, suit)
    %__MODULE__{cards: cards |> Enum.shuffle()}
  end

  def take_random_cards(%__MODULE__{} = _deck, 0), do: {:error, :cannot_take_zero_cards}
  def take_random_cards(%__MODULE__{} = deck, num_to_take) when num_to_take > length(deck.cards), do: {:error, :deck_has_insufficient_cards}
  def take_random_cards(%__MODULE__{} = deck, num_to_take) do
    {taken_cards, remaining_deck_cards} = deck.cards |> Enum.split(num_to_take)
    updated_deck = %__MODULE__{cards: remaining_deck_cards}
    {:ok, taken_cards, updated_deck}
  end

  def remove_cards(%__MODULE__{} = _deck, []), do: {:error, :cannot_remove_zero_cards}
  def remove_cards(%__MODULE__{} = deck, cards_to_remove) do
    cards_not_in_deck = cards_to_remove |> Enum.filter(& &1 not in deck.cards)
    case cards_not_in_deck do
      [] -> {:ok, %__MODULE__{cards: deck.cards |> Enum.reject(& &1 in cards_to_remove)} }
      _ -> {:error, :cannot_remove_card_not_in_deck}
    end
  end
end
