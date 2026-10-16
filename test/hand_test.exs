defmodule HandTest do
  use ExUnit.Case

  alias PokerCalculator.Models.{Hand, Card, Deck}

  setup do
    deck = Deck.new()
    %{deck: deck}
  end

  describe "new/1" do
    test "can create a hand with no cards" do
      {:ok, hand} = Hand.new()

      assert length(hand.cards) == 0
    end

    test "can create a hand with starting cards", %{deck: deck} do
      {:ok, starting_cards, _} = deck |> Deck.take_random_cards(2)

      {:ok, hand} = Hand.new(starting_cards)

      for card <- starting_cards, do: assert card in hand.cards
    end

    test "can't create a hand with more than seven cards", %{deck: deck} do
      {:ok, cards, _} = deck |> Deck.take_random_cards(8)

      assert {:error, :hand_cannot_have_more_than_seven_cards} = Hand.new(cards)
    end

    test "can't create a hand with duplicate cards" do
      cards = [Card.new(:eight, :hearts), Card.new(:nine, :clubs), Card.new(:eight, :hearts)]

      assert {:error, :hand_cannot_contain_duplicate_cards} = Hand.new(cards)
    end
  end

  describe "add_cards/2" do
    test "can add cards to a hand", %{deck: deck} do
      {:ok, initial_cards, deck} = deck |> Deck.take_random_cards(1)
      {:ok, hand} = Hand.new(initial_cards)
      {:ok, cards_to_add, _} = deck |> Deck.take_random_cards(2)

      assert {:ok, updated_hand} = hand |> Hand.add_cards(cards_to_add)

      for card <- cards_to_add, do: assert card in updated_hand.cards
      for card <- initial_cards, do: assert card in updated_hand.cards
    end

    test "can't add more than seven cards to a hand", %{deck: deck} do
      {:ok, hand} = Hand.new()
      {:ok, cards_to_add, _} = deck |> Deck.take_random_cards(8)

      assert {:error, :hand_cannot_have_more_than_seven_cards} = hand |> Hand.add_cards(cards_to_add)
    end

    test "can't add cards to a hand taking total to more than seven cards", %{deck: deck} do
      {:ok, initial_cards, deck} = deck |> Deck.take_random_cards(3)
      {:ok, hand} = Hand.new(initial_cards)
      {:ok, cards_to_add, _} = deck |> Deck.take_random_cards(5)

      assert {:error, :hand_cannot_have_more_than_seven_cards} = hand |> Hand.add_cards(cards_to_add)
    end

    test "can't add cards to a hand that are already in hand", %{deck: deck} do
      {:ok, [_, duplicate_card] = initial_cards, _} = deck |> Deck.take_random_cards(2)
      {:ok, hand} = Hand.new(initial_cards)

      assert {:error, :hand_cannot_contain_duplicate_cards} = hand |> Hand.add_cards([duplicate_card])
    end
  end
end
