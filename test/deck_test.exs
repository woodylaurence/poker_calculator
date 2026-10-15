defmodule DeckTest do
  use ExUnit.Case

  alias PokerCalculator.Models.{Card, Deck}

  @all_cards for rank <- Card.ranks(), suit <- Card.suits(), do: Card.new(rank, suit)

  test "can create a deck" do
    deck = Deck.new()

    assert length(deck.cards) == 52
    for deck_card <- deck.cards, do: assert deck_card in @all_cards
    for card <- @all_cards, do: assert card in deck.cards
  end

  test "created deck's cards are shuffled" do
    deck = Deck.new()

    refute deck.cards == @all_cards
  end

  test "cannot take zero cards from the deck" do
    deck = Deck.new()

    assert {:error, :cannot_take_zero_cards} = deck|> Deck.take_random_cards(0)
  end

  test "can take a random card from the deck" do
    deck = Deck.new()

    assert {:ok, [card], updated_deck} = deck |> Deck.take_random_cards(1)
    assert card not in updated_deck.cards
  end

  test "can take multiple random cards from the deck" do
    deck = Deck.new()

    assert {:ok, [_, _, _] = cards, updated_deck} = deck |> Deck.take_random_cards(3)
    for card <- cards, do: assert card not in updated_deck.cards
  end

  test "cannot take more cards than there are left in the deck" do
    deck = Deck.new()
    {:ok, _, deck} = deck |> Deck.take_random_cards(30)

    assert {:error, :deck_has_insufficient_cards} = deck |> Deck.take_random_cards(30)
  end

  test "cannot remove zero cards from the deck" do
    deck = Deck.new()

    assert {:error, :cannot_remove_zero_cards} = deck |> Deck.remove_cards([])
  end

  test "cannot remove card that is not in deck" do
    deck = Deck.new()
    card_to_remove = Card.new(:nine, :hearts)

    {:ok, updated_deck} = deck |> Deck.remove_cards([card_to_remove])

    assert {:error, :cannot_remove_card_not_in_deck} = updated_deck |> Deck.remove_cards([card_to_remove])
  end

  test "can remove cards from deck" do
    deck = Deck.new()
    cards_to_remove = [Card.new(:nine, :hearts), Card.new(:ace, :spades)]

    assert {:ok, updated_deck} = deck |> Deck.remove_cards(cards_to_remove)
    assert for card <- cards_to_remove, do: card not in updated_deck.cards
  end
end
